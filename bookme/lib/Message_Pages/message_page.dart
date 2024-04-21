import 'package:flutter/material.dart';
import 'package:bookme/crud.dart'; // Ensure this import points to your actual CRUD class
import 'appointment_page.dart'; // Make sure this import points to your actual AppointmentPage class
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagePage extends StatefulWidget {
  final String chatRoomId;
  final String contactName;

  const MessagePage({
    Key? key,
    required this.chatRoomId,
    required this.contactName,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> messages = []; // List to store messages
  TextEditingController messageController = TextEditingController();
  final CRUD _crud = CRUD();
  bool showAppointmentButtons =
      false; // To control the visibility of appointment buttons

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    try {
      QuerySnapshot snapshot = await _crud.getMessageList(widget.chatRoomId);
      List<Map<String, dynamic>> fetchedMessages =
          snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] =
            doc.id; // Include document ID if needed for operations like update
        return data;
      }).toList();

      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  void _sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _crud.sendMessage(widget.chatRoomId, messageController.text);
      messageController.clear();
      _loadMessages(); // Reload the message list to include the new message
    }
  }

  void addAppointmentDetails(String details) async {
    // Get the current user ID as the sender
    String currentUserUID = _crud.currentUserUid;

    try {
      // Fetch participant UIDs for the current chat room
      List<String> participantUIDs =
          await _crud.getParticipantUIDs(widget.chatRoomId);

      // Check if current user is part of participants; add if not
      if (!participantUIDs.contains(currentUserUID)) {
        participantUIDs.add(currentUserUID);
      }

      // Concatenate appointment details with participant info for clarity or use as needed
      String messageDetails =
          "$details, Participants: ${participantUIDs.join(', ')}";

      // Send appointment message including the participants
      _crud
          .sendAppointmentMessage(
              widget.chatRoomId, messageDetails, participantUIDs)
          .then((_) {
        _loadMessages(); // Reload messages to show the new appointment
      }).catchError((error) {
        print("Failed to add appointment details: $error");
      });
    } catch (e) {
      print("Error processing appointment details: $e");
    }
  }

  void _updateAppointmentStatus(String messageId, String status) {
    _crud
        .updateAppointmentStatus(widget.chatRoomId, messageId, status)
        .then((_) {
      _loadMessages(); // Refresh messages to reflect the updated status
    }).catchError((error) {
      print("Failed to update appointment status: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.contactName}\'s Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message =
                    messages[index]; // Define message here for correct access
                return ListTile(
                  title: Text(message['text']),
                  subtitle: Text(
                      'Sent at: ${message['timestamp'].toDate().toString()}'),
                  trailing: message['type'] == 'appointment' &&
                          message['status'] == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                // Call the approveAppointment function
                                _crud
                                    .approveAppointment(
                                  widget.chatRoomId,
                                  messages[index][
                                      'id'], // Ensure message ID is correctly retrieved
                                )
                                    .then((_) {
                                  _loadMessages(); // Refresh messages to reflect the updated status
                                }).catchError((error) {
                                  print(
                                      "Failed to approve appointment: $error");
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _updateAppointmentStatus(
                                  message['id'], 'rejected'),
                            ),
                          ],
                        )
                      : null,
                );
              },
            ),
          ),
          if (showAppointmentButtons) // Show buttons conditionally
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        messages.add({
                          "text": "Appointment Approved",
                          "timestamp": Timestamp.now()
                        });
                        showAppointmentButtons =
                            false; // Hide the buttons after action
                      });
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        messages.add({
                          "text": "Appointment Rejected",
                          "timestamp": Timestamp.now()
                        });
                        showAppointmentButtons =
                            false; // Hide the buttons after action
                      });
                    },
                    child: const Text('Reject'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _sendMessage(),
                  child: const Text('Send'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the appointment creation page and pass the callback function
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentPage(onSave: addAppointmentDetails),
                      ),
                    );
                  },
                  child: const Text('Create Appointment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

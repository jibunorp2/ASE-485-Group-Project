import 'package:flutter/material.dart';
import 'appointment_page.dart';

class MessagePage extends StatefulWidget {
  final int buttonNumber;
  final String contactName;

  const MessagePage({
    Key? key,
    required this.buttonNumber,
    required this.contactName,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<String> messages = []; // List to store messages
  bool showAppointmentButtons =
      false; // To control the visibility of appointment buttons
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.contactName}\'s Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Text(messages[index]);
                    },
                  ),
                ),
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
                        // Logic for approving the appointment
                        setState(() {
                          // Perform actions for approving the appointment
                          messages.add("Appointment Approved");
                          showAppointmentButtons =
                              false; // Hide the buttons after action
                        });
                      },
                      child: const Text('Approve'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Logic for rejecting the appointment
                        setState(() {
                          // Perform actions for rejecting the appointment
                          messages.add("Appointment Rejected");
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(labelText: 'Type a message'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add the typed message to the list
                      setState(() {
                        messages.add(messageController.text);
                        messageController.clear(); // Clear the input field
                      });
                    },
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
      ),
    );
  }

  void addAppointmentDetails(String details) {
    setState(() {
      messages.add(details);
      showAppointmentButtons = true; // Show the buttons after appointment added
    });
  }
}

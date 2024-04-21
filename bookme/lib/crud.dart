// crud.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // For generating random numbers

class CRUD {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Expose currentUserUid for external use
  String get currentUserUid => _auth.currentUser?.uid ?? "";

  // Inside CRUD class
  Future<bool> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user!.updateDisplayName(name);
      String userID = _generateUserID();

      // Save user info in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'user_ID': userID,
        'name': name,
      });

      // Create a new contact list for the user
      await _firestore.collection('contact_lists').doc(user.uid).set({
        'contact_list_ID': user.uid,
        'user_ID': userID,
        'users_in_list': [],
      });

      // Create a new appointment list for the user
      await _firestore.collection('appointment_lists').doc(user.uid).set({
        'appointment_list_ID': user.uid,
        'appointments': [],
      });

      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  // Function to sign in a user
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error signing in: $e");
      return false;
    }
  }

  // Function to fetch contact details
  Future<List<Map<String, dynamic>>> fetchContacts() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var contactListDoc =
          await _firestore.collection('contact_lists').doc(user.uid).get();
      List<dynamic> userIDs =
          List<dynamic>.from(contactListDoc.data()?['users_in_list'] ?? []);
      List<Map<String, dynamic>> contacts = [];

      for (String userID in userIDs) {
        var userDoc = await _firestore
            .collection('users')
            .where('user_ID', isEqualTo: userID)
            .get();
        if (userDoc.docs.isNotEmpty) {
          contacts.add(
              {'name': userDoc.docs.first.data()['name'], 'user_ID': userID});
        }
      }
      return contacts;
    }
    return [];
  }

  // Function to add a contact and create/update chat room
  Future<void> addContact(String userIDToAdd) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Fetch the current user's 6-digit ID
      var currentUserDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      String? currentUser6DigitID = currentUserDoc.data()?['user_ID'];

      if (currentUser6DigitID != null) {
        // Fetch the other user's UID using the 6-digit ID
        var userToAddDoc = await _firestore
            .collection('users')
            .where('user_ID', isEqualTo: userIDToAdd)
            .get();
        if (userToAddDoc.docs.isNotEmpty) {
          String userToAddUID = userToAddDoc.docs.first.id;

          // Update both users' contact lists
          await _firestore
              .collection('contact_lists')
              .doc(currentUser.uid)
              .update({
            'users_in_list': FieldValue.arrayUnion([userIDToAdd]),
          });
          await _firestore
              .collection('contact_lists')
              .doc(userToAddUID)
              .update({
            'users_in_list': FieldValue.arrayUnion([currentUser6DigitID]),
          });

          // Create or retrieve chat room
          String chatRoomID =
              await getOrCreateChatRoom(currentUser.uid, userToAddUID);
          print("Chat room ID: $chatRoomID");
        }
      }
    }
  }

  // Helper function to generate a random 6-digit user ID
  String _generateUserID() {
    var random = Random();
    int max = 1000000; // Making sure the ID has exactly 6 digits
    int idNum = random.nextInt(max);
    return idNum.toString().padLeft(6, '0'); // Ensure the ID is 6 digits long
  }

  // Ensure chat rooms are identified using only Firebase Auth UIDs
  Future<String> getOrCreateChatRoom(String user1UID, String user2UID) async {
    final chatRoomQuery = await _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: user1UID)
        .get();

    for (var doc in chatRoomQuery.docs) {
      var participants = doc.data()['participants'] as List;
      if (participants.contains(user2UID)) {
        return doc.id; // Chat room already exists
      }
    }

    // Create new chat room if none exists
    var newChatRoom = await _firestore.collection('chat_rooms').add({
      'participants': [user1UID, user2UID],
      'created_at': FieldValue.serverTimestamp(),
    });

    return newChatRoom.id;
  }

  // Function to send a message
  Future<void> sendMessage(String chatRoomID, String message) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add({
      'sender_id': _auth.currentUser?.uid,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<QuerySnapshot> getMessageList(String chatRoomID) {
    // This should query Firestore and return a QuerySnapshot
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp')
        .get();
  }

  // Method to get user UID by user_ID
  Future<String> getUserUIDByUserID(String userID) async {
    var userQuery = await _firestore
        .collection('users')
        .where('user_ID', isEqualTo: userID)
        .limit(1)
        .get();

    if (userQuery.docs.isNotEmpty) {
      return userQuery.docs.first.id; // Returning the UID of the user
    } else {
      throw Exception('User not found');
    }
  }

  // In crud.dart
  Future<void> sendAppointmentMessage(String chatRoomID, String messageDetails,
      List<String> participantUIDs) async {
    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc();

    await messageRef.set({
      'id': messageRef.id,
      'sender_id':
          _auth.currentUser?.uid, // ID of the user who sends the appointment
      'text': messageDetails,
      'type': 'appointment', // Identifying this message as an appointment
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending', // Initial status of the appointment
      'participants': participantUIDs, // Include participants in the message
    });
  }

  Future<void> updateAppointmentStatus(
      String chatRoomID, String messageID, String newStatus) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(messageID)
        .update({'status': newStatus});
  }

  Future<void> approveAppointment(String chatRoomId, String messageId) async {
    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);
    DocumentSnapshot messageDoc = await messageRef.get();

    if (messageDoc.exists && messageDoc.data() != null) {
      Map<String, dynamic> messageData =
          messageDoc.data()! as Map<String, dynamic>;
      if (messageData['status'] == 'pending' &&
          messageData.containsKey('participants')) {
        List<String> participantUIDs =
            List<String>.from(messageData['participants']);
        if (participantUIDs.isNotEmpty) {
          var appointment = {
            'appointment_ID':
                Random().nextInt(1000000).toString().padLeft(6, '0'),
            'title': messageData['title'],
            'type': messageData['type'],
            'date': messageData['date'],
            'time': messageData['time'],
            'details': messageData['details']
          };

          // Add appointment to both users' lists
          for (String uid in participantUIDs) {
            await _firestore.collection('appointment_lists').doc(uid).update({
              'appointments': FieldValue.arrayUnion([appointment])
            });
          }

          // Update the message status to 'approved'
          await messageRef.update({'status': 'approved'});
        } else {
          throw Exception(
              "Participants data missing or invalid in the appointment message");
        }
      } else {
        throw Exception("Appointment is already processed or data is missing.");
      }
    } else {
      throw Exception("Appointment message not found or data is null");
    }
  }

  // Method in CRUD to get participant UIDs from a chat room
  Future<List<String>> getParticipantUIDs(String chatRoomId) async {
    try {
      DocumentSnapshot chatRoomDoc =
          await _firestore.collection('chat_rooms').doc(chatRoomId).get();
      if (chatRoomDoc.exists && chatRoomDoc.data() != null) {
        Map<String, dynamic> data = chatRoomDoc.data() as Map<String, dynamic>;
        if (data.containsKey('participants') && data['participants'] is List) {
          // Convert all items in the list to String, assuming they are stored as such
          return List<String>.from(data['participants']);
        } else {
          throw Exception("Participants field is missing or not a list");
        }
      } else {
        throw Exception("Chat room does not exist or has no data");
      }
    } catch (e) {
      print("Failed to fetch participant UIDs: $e");
      throw Exception("Failed to fetch participant UIDs");
    }
  }
}

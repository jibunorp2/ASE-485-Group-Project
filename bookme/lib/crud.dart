// crud.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // For generating random numbers

class CRUD {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Expose currentUserUid for external use
  String get currentUserUid => _auth.currentUser?.uid ?? "";

  // Function to register a new user
  Future<bool> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user!.updateDisplayName(name);

      // Generate a unique 6-digit user ID
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
    String id = '';
    for (int i = 0; i < 6; i++) {
      id += random.nextInt(10).toString();
    }
    return id;
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

  // Function to fetch messages
  Future<List<Map<String, dynamic>>> getMessageList(String chatRoomID) async {
    var messages = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    return messages.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // CRUD.dart

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
}

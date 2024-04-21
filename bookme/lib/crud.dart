// crud.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // For generating random numbers

class CRUD {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Function to add a contact and update both users' contact lists
  Future<void> addContact(String userIDToAdd) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Fetch the current user's 6-digit ID
      var currentUserDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      String? currentUser6DigitID = currentUserDoc.data()?['user_ID'];

      if (currentUser6DigitID != null) {
        // Update the current user's contact list
        await _firestore
            .collection('contact_lists')
            .doc(currentUser.uid)
            .update({
          'users_in_list': FieldValue.arrayUnion([userIDToAdd]),
        });

        // Fetch the Firestore user document for the user to add
        var userToAddDoc = await _firestore
            .collection('users')
            .where('user_ID', isEqualTo: userIDToAdd)
            .get();
        if (userToAddDoc.docs.isNotEmpty) {
          String userToAddUID = userToAddDoc.docs.first.id;

          // Update the other user's contact list to include the current user's ID
          await _firestore
              .collection('contact_lists')
              .doc(userToAddUID)
              .update({
            'users_in_list': FieldValue.arrayUnion([currentUser6DigitID]),
          });
        } else {
          print("User not found");
        }
      } else {
        print("Current user 6-digit ID not found");
      }
    } else {
      print("No current user logged in");
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
}

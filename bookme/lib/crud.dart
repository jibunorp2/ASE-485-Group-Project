// crud.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CRUD {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to register a new user
  Future<bool> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await user!.updateDisplayName(name);
      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  // Function to sign in a user
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print("Error signing in: $e");
      return false;
    }
  }
}

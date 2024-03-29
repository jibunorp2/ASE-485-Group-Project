// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your login page

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.teal
            ], // Add your desired gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjust the width as needed
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black), // Add border to TextField
                    borderRadius: BorderRadius.circular(
                        8.0), // Optional: Add border radius
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0), // Adjust the padding as needed
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjust the width as needed
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black), // Add border to TextField
                    borderRadius: BorderRadius.circular(
                        8.0), // Optional: Add border radius
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0), // Adjust the padding as needed
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjust the width as needed
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black), // Add border to TextField
                    borderRadius: BorderRadius.circular(
                        8.0), // Optional: Add border radius
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0), // Adjust the padding as needed
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 32),
                //Register Button
                ElevatedButton(
                  onPressed: () {
                    if (validateName(_nameController.text) &&
                        validateEmail(_emailController.text) &&
                        validatePass(_passwordController.text)) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Set background color
                    foregroundColor: Colors.white, // Set text color to black
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//returns true if at least 1 number, 1 letter, and 7 characters
bool validatePass(String password) {
  return RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{7,}$').hasMatch(password);
}

//returns true if email follows x@y.z format
bool validateEmail(String email) {
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
      .hasMatch(email);
}

//returns true if only lettters are found and is not empty
bool validateName(String name) {
  // Check if the name is not blank and contains only letters
  return name.isNotEmpty && !RegExp(r'[^a-zA-Z]').hasMatch(name);
}

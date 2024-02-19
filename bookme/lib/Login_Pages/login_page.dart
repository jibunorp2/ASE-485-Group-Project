// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../contact_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
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
                      0.3, // Adjust the width as needed
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
                      border:
                          InputBorder.none, // Hide TextField's default border
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.3, // Adjust the width as needed
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
                      border:
                          InputBorder.none, // Hide TextField's default border
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactPage(),
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
                  child: const Text('Login', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// login_page.dart
import 'package:flutter/material.dart';
import 'package:bookme/crud.dart'; // Ensure this import points to your actual CRUD class file
import '../Contact_Pages.dart/contact_page.dart';

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
            colors: [Colors.blue, Colors.teal],
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
                buildTextField(_emailController, 'Email', false),
                const SizedBox(height: 16),
                buildTextField(_passwordController, 'Password', true),
                const SizedBox(height: 32),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
        obscureText: obscureText,
        keyboardType:
            obscureText ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          bool success = await CRUD().signIn(
            _emailController.text,
            _passwordController.text,
          );
          if (success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactPage(),
              ),
            );
          } else {
            // Optionally show an error message if login fails
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Login failed. Please check your credentials.")));
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
      child: const Text('Login', style: TextStyle(fontSize: 20)),
    );
  }
}

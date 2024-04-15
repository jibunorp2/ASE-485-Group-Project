// my_app.dart
import 'package:flutter/material.dart';
import 'Login_Pages/sign_in_page.dart';
import 'crud.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignInPage(),
    );
  }
}

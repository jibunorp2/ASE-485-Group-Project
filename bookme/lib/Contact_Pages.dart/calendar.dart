import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar'),
      ),
      body: const Center(
        child: Text(
          'Calendar Content Goes Here',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

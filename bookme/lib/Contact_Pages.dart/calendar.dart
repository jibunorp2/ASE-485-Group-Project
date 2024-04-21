import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<int, bool> dayStatus;

  @override
  void initState() {
    super.initState();
    dayStatus = generateDayStatusMap(31); // All days are initially green
    _fetchAppointments(); // Fetch appointments from Firestore
  }

  Future<void> _fetchAppointments() async {
    // Query appointments for the current user from Firestore
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId',
              isEqualTo: 'currentUserId') // Replace with actual user ID
          .get();

      // Update dayStatus based on appointments
      snapshot.docs.forEach((DocumentSnapshot doc) {
        Timestamp appointmentDate = doc['date'] as Timestamp;
        int day = appointmentDate.toDate().day;
        setState(() {
          dayStatus[day] = true; // Mark the day as busy (red)
        });
      });
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Map<int, bool> generateDayStatusMap(int daysInMonth) {
    return Map<int, bool>.fromIterable(
      List.generate(daysInMonth, (index) => index + 1),
      key: (day) => day as int,
      value: (_) => false, // Default value set to false (green)
    );
  }

  void _showDaySchedule(int day) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Schedule for Day $day'),
          content: Text('Add your schedule details here.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, // 7 columns for each day of the week
        ),
        itemCount: 31, // 31 days
        itemBuilder: (BuildContext context, int index) {
          int day = index + 1;
          return GestureDetector(
            onTap: () {
              _showDaySchedule(day);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: dayStatus[day]! ? Colors.red : Colors.green,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

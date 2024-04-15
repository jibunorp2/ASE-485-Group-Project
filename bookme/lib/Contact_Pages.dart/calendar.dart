import 'package:flutter/material.dart';

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
    dayStatus = generateDayStatusMap(31,
        defaultValue: true); // Assuming 31 days in January
  }

  Map<int, bool> generateDayStatusMap(int daysInMonth,
      {bool defaultValue = true}) {
    return Map<int, bool>.fromIterable(
      List.generate(daysInMonth, (index) => index + 1),
      key: (day) => day as int,
      value: (_) => defaultValue,
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
              setState(() {
                // Toggle busy status of the day
                dayStatus[day] = !dayStatus[day]!;
              });
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
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showDaySchedule(day);
                        },
                        customBorder: CircleBorder(),
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

import 'package:flutter/material.dart';
import 'package:bookme/crud.dart';

class AppointmentPage extends StatefulWidget {
  final Function(String) onSave;

  const AppointmentPage({Key? key, required this.onSave}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: typeController.text.isNotEmpty
                        ? typeController.text
                        : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        typeController.text = newValue ?? '';
                      });
                    },
                    items: <String>[
                      'Meeting',
                      'Consultation',
                      'Follow-up'
                    ] // Replace with your unique types
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Type',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null &&
                          selectedDate != DateTime.now()) {
                        setState(() {
                          dateController.text =
                              "${selectedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: timeController,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          timeController.text = selectedTime.format(context);
                        });
                      }
                    },
                    decoration: InputDecoration(labelText: 'Time'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: detailController,
                    decoration: const InputDecoration(labelText: 'Details'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      String details =
                          'Title: ${titleController.text}, Type: ${typeController.text}, Date: ${dateController.text}, Time: ${timeController.text}, Details: ${detailController.text}';
                      widget.onSave(details);
                      Navigator.pop(context);
                    },
                    child: const Text('Send Appointment'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSave() {
    // Collect data from the text controllers
    String details = 'Title: ${titleController.text}, '
        'Type: ${typeController.text}, '
        'Date: ${dateController.text}, '
        'Time: ${timeController.text}, '
        'Details: ${detailController.text}';

    // Use the onSave callback passed from the parent widget to pass the data
    widget.onSave(details);

    // Optionally, navigate back or show a success message
    Navigator.pop(context);
  }
}

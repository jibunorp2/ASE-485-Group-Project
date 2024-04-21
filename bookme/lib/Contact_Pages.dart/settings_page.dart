import 'package:flutter/material.dart';
import 'package:bookme/crud.dart'; // Import your CRUD class here

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final CRUD _crud = CRUD();
  Map<String, dynamic>? _contactListData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter Name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text.trim();
                Map<String, dynamic>? contactListData =
                    await _crud.getContactListDataByName(name);
                setState(() {
                  _contactListData = contactListData;
                });
              },
              child: Text('Get Contact List Data'),
            ),
            SizedBox(height: 20),
            _contactListData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _contactListData!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('${entry.key}: ${entry.value}'),
                      );
                    }).toList(),
                  )
                : SizedBox(), // Show contact list data if available
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

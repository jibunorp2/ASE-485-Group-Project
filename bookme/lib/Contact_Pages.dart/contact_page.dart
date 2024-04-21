// contact_page.dart
import 'package:flutter/material.dart';
import 'package:bookme/crud.dart'; // Ensure this import points to your CRUD class
import 'settings_page.dart'; // Adjust path as needed
import 'calendar.dart'; // Adjust path as needed
import '../Message_Pages/message_page.dart'; // Adjust path as needed

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final CRUD _crud = CRUD();
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    var fetchedContacts = await _crud.fetchContacts();
    setState(() {
      contacts = fetchedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarPage()));
            },
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Contacts List'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Center(child: Text(contacts[index]['name'])),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessagePage(
                                  buttonNumber: index + 1,
                                  contactName: contacts[index]['name'])));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewContactDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showNewContactDialog(BuildContext context) async {
    TextEditingController newContactController = TextEditingController();

    String? newContactID = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Contact'),
          content: TextField(
            controller: newContactController,
            decoration: const InputDecoration(labelText: 'Enter User ID'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, newContactController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (newContactID != null && newContactID.isNotEmpty) {
      await _crud.addContact(newContactID);
      _loadContacts(); // Refresh the contact list
    }
  }
}

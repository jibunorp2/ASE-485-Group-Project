// contact_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Message_Pages/message_page.dart';

class Contact {
  String name;
  String code;

  Contact({required this.name, required this.code});
}

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [
    Contact(name: 'John Doe', code: '123456'),
    Contact(name: 'Jane Smith', code: '234567'),
    Contact(name: 'Bob Johnson', code: '345678'),
    Contact(name: 'Alice Williams', code: '456789'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Page'),
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
                  return InkWell(
                    onTap: () {
                      _navigateToMessagePage(index);
                    },
                    child: ListTile(
                      title: Center(
                        child: Column(
                          children: [
                            Text(contacts[index].name),
                            Text('Code: ${contacts[index].code}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewContactDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show a dialog for adding a new contact
  // Need to add this directly to the database somehow, then refresh page
  Future<void> _showNewContactDialog(BuildContext context) async {
    String? newContactName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newContactController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Contact'),
          content: Column(
            children: [
              TextField(
                controller: newContactController,
                decoration: const InputDecoration(labelText: 'Contact Name'),
              ),
              const SizedBox(height: 16),
              Text(
                'A 6-digit code will be generated for the new contact.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, newContactController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    // Add the new contact to the list if not null (user didn't cancel)
    if (newContactName != null && newContactName.isNotEmpty) {
      String newContactCode = _generateRandomCode();
      Contact newContact = Contact(name: newContactName, code: newContactCode);

      setState(() {
        contacts.add(newContact);
      });
    }
  }

  // Function to generate a random 6-digit code
  String _generateRandomCode() {
    // Implement your logic to generate a random 6-digit code here
    // For example, you can use a random number generator or any specific algorithm
    // Make sure the generated code is unique if needed
    // For simplicity, let's use a constant value for now
    return '987654';
  }

  // Function to navigate to the MessagePage with the selected contact
  void _navigateToMessagePage(int index) {
    Contact selectedContact = contacts[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(
          buttonNumber: index + 1,
          contactName: selectedContact.name,
        ),
      ),
    );
  }
}

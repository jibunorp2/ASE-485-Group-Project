// contact_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:bookme/Contact_Pages.dart/settings_page.dart';
import 'package:flutter/material.dart';
import '../Message_Pages/message_page.dart';

class Contact {
  String name;
  String code;

  Contact({required this.name, required this.code});
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
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
                    title: Center(
                      child: Column(
                        children: [
                          Text(contacts[index].name),
                          Text('Code: ${contacts[index].code}'),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, index);
                      },
                    ),
                    onTap: () {
                      _navigateToMessagePage(index);
                    },
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
              const Text(
                'A 6-digit code will be generated for the new contact.',
                style: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
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

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content:
              Text('Are you sure you want to delete ${contacts[index].name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteContact(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a contact from the list
  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }
}

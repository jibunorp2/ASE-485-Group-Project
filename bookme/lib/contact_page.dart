// contact_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'message_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

//On load this function should grab the current list of contacts and then build them out. Also needs to refresh when a new contact is added
class _ContactPageState extends State<ContactPage> {
  List<String> contacts = []; // List to store contacts

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
                      title: Text(contacts[index]),
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
  //Need to add this directly to database somehow, then refresh page
  Future<void> _showNewContactDialog(BuildContext context) async {
    String newContact = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newContactController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Contact'),
          content: TextField(
            controller: newContactController,
            decoration: const InputDecoration(labelText: 'Contact Name'),
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
    if (newContact.isNotEmpty) {
      setState(() {
        contacts.add(newContact);
      });
    }
  }

  // Function to navigate to the MessagePage with the selected contact
  void _navigateToMessagePage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(buttonNumber: index + 1),
      ),
    );
  }
}

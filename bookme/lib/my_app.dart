// contact_page.dart
import 'package:flutter/material.dart';
import 'message_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<String> contacts = []; // This list will still be used for the UI

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

    if (newContact.isNotEmpty) {
      setState(() {
        contacts.add(newContact); // Update UI
      });
      _addContactToFirestore(newContact); // Add contact to Firestore
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

  // New function to add a contact to Firestore
  Future<void> _addContactToFirestore(String contactName) async {
    await FirebaseFirestore.instance.collection('collectionIDthing').add({
      'fieldNameThing': contactName, // Field you want to update
    });
  }
}

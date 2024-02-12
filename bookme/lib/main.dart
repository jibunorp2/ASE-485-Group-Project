// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactPage()),
            );
          },
          child: const Text('Log In'),
        ),
      ),
    );
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

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

class MessagePage extends StatefulWidget {
  final int buttonNumber;

  const MessagePage({Key? key, required this.buttonNumber}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<String> messages = []; // List to store messages
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact ${widget.buttonNumber} Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Contact ${widget.buttonNumber} Name'),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Text(messages[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add the typed message to the list
                    setState(() {
                      messages.add(messageController.text);
                      messageController.clear(); // Clear the input field
                    });
                  },
                  child: const Text('Send'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Upload file logic
                    // You can implement the logic for file upload here
                  },
                  child: const Text('Upload File'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the appointment creation page and pass the callback function
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentPage(onSave: addAppointmentDetails),
                      ),
                    );
                  },
                  child: const Text('Create Appointment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addAppointmentDetails(String details) {
    setState(() {
      messages.add(details);
    });
  }
}

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add a New Contact'),
            SizedBox(height: 20),
            // Add form fields or UI for adding a new contact
          ],
        ),
      ),
    );
  }
}

class AppointmentPage extends StatefulWidget {
  final Function(String) onSave;

  const AppointmentPage({super.key, required this.onSave});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the callback function to save appointment details
                String details =
                    'Date: ${dateController.text}, Time: ${timeController.text}, Type: ${typeController.text}, Reason: ${reasonController.text}, Details: ${detailsController.text}';
                widget.onSave(details);

                // Close the current page
                Navigator.pop(context);
              },
              child: const Text('Save Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

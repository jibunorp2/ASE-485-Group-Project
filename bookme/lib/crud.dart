import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUD {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signing up the user
  Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //this stores the user details in Firestore (excluding the password cuz security)
      await _db.collection('User').doc(userCredential.user!.uid).set(
          {'user_ID': userCredential.user!.uid, 'name': name, 'email': email});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //logging in the user
  Future<bool> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //logging out the user
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // The User's Contact List
  Future<bool> addToContacts(String userEmail, String contactEmail) async {
    try {
      var contactUser = await _db
          .collection('User')
          .where('email', isEqualTo: contactEmail)
          .get();
      if (contactUser.docs.isEmpty) {
        return false;
      }
      var contactUserID = contactUser.docs.first.get('user_ID');
      await _db.collection('Contact List').add({
        'user_ID': _auth.currentUser!.uid,
        'contact_user_ID': contactUserID,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<String>> getUserList() async {
    List<String> usernames = [];
    var contacts = await _db
        .collection('Contact List')
        .where('user_ID', isEqualTo: _auth.currentUser!.uid)
        .get();
    for (var doc in contacts.docs) {
      var userId = doc.get('contact_user_ID');
      var user = await _db.collection('User').doc(userId).get();
      usernames.add(user.get('name'));
    }
    return usernames;
  }

  //messaging
  Future<List<String>> getMessageList(String chatroomId) async {
    List<String> messageIds = [];
    var messages = await _db
        .collection('Message')
        .where('chatroom_ID', isEqualTo: chatroomId)
        .orderBy('timestamp')
        .get();
    for (var message in messages.docs) {
      messageIds.add(message.id);
    }
    return messageIds;
  }

  Future<void> sendMessage(
      String chatroomId, String receiverId, String messageText) async {
    await _db.collection('Message').add({
      'sender_ID': _auth.currentUser!.uid,
      'receiver_ID': receiverId,
      'message_text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
      'chatroom_ID': chatroomId,
    });
  }

  //appointment booking
  Future<void> addAppointment(String title, String type, DateTime date,
      String time, String description, String bookeeId) async {
    var appointment = await _db.collection('Appointment').add({
      'title': title,
      'type': type,
      'date': date,
      'time': time,
      'description': description,
      'booker_ID': _auth.currentUser!.uid,
      'bookee_ID': bookeeId,
    });
    await _db.collection('Appointment List').add({
      'user_ID': _auth.currentUser!.uid,
      'appointment_ID': appointment.id,
    });
  }

  Future<void> deleteAppointment(String appointmentId) async {
    //first, delete the appointment from the 'Appointment' collection.
    await _db.collection('Appointment').doc(appointmentId).delete();

    //then, find the corresponding entry in the 'Appointment List' collection and delete it.
    //(assuming that there's only one entry per appointment ID for simplicity)
    var appointmentListEntry = await _db
        .collection('Appointment List')
        .where('user_ID', isEqualTo: _auth.currentUser!.uid)
        .where('appointment_ID', isEqualTo: appointmentId)
        .get();

    //check if the document exists, and then proceed to delete.
    for (var doc in appointmentListEntry.docs) {
      await _db.collection('Appointment List').doc(doc.id).delete();
    }
  }

  bool crossCheck(
      Map<String, dynamic> appointment1, Map<String, dynamic> appointment2) {
    DateTime date1 = (appointment1['date'] as Timestamp).toDate();
    DateTime date2 = (appointment2['date'] as Timestamp).toDate();

    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

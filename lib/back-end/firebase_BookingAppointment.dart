import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // Function to create an appointment in Firestore with service, date, time, and comment
  Future<void> createAppointment(
      String service, String date, String time, String comment) async {
    // Get the current user's UID
    User? user = FirebaseAuth.instance.currentUser;
    String? username = user?.uid;

    // if (username == null) {
    //   print('User is not logged in'); // Debug message
    //   return;
    // }

    CollectionReference appointments =
        FirebaseFirestore.instance.collection('appointments');

    try {
      await appointments.add({
        'username': username,
        'service': service,
        'date': date,
        'time': time,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Appointment added successfully"); // Debug message
    } catch (e) {
      print("Error adding appointment: $e"); // Error message
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // Function to fetch appointment history for the logged-in user (one-time fetch)
  Future<List<Map<String, dynamic>>> fetchAppointmentHistory() async {
    // Get the currently logged-in user's UID
    User? user = FirebaseAuth.instance.currentUser;
    String? username = user?.uid; // Fetch UID of the logged-in user

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('username',
              isEqualTo: username) // Filter by the logged-in user's UID
          .orderBy('timestamp', descending: true) // Sort by latest first
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No appointments found for username: $username"); // Debug log
      }

      // Convert query result into a list of maps
      return querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id
              }) // Include the document ID
          .toList();
    } catch (e) {
      print("Error fetching appointments: $e"); // Debug error
      return [];
    }
  }

  // Stream function to get real-time updates for the logged-in user's appointments
  Stream<List<Map<String, dynamic>>> getAppointmentHistoryStream() {
    // Get the currently logged-in user's UID
    User? user = FirebaseAuth.instance.currentUser;
    String? username = user?.uid; // Fetch UID of the logged-in user

    // Return a Firestore stream filtered by the logged-in user's UID
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('username',
            isEqualTo: username) // Filter by the logged-in user's UID
        .orderBy('timestamp', descending: true) // Sort by latest first
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id, // Include the document ID
              };
            }).toList());
  }

  // Function to delete an appointment by its document ID
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      // Delete the appointment from the Firestore collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId) // Specify the document ID
          .delete();

      print("Appointment with ID: $appointmentId deleted successfully");
    } catch (e) {
      print("Error deleting appointment: $e");
    }
  }
}

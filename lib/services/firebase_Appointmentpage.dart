// // services/firebase_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseService {
//   final CollectionReference appointmentsCollection =
//       FirebaseFirestore.instance.collection('appointments');

//   Future<void> saveAppointment({
//     required String service,
//     required String date,
//     required String time,
//     required String comment,
//   }) async {
//     try {
//       await appointmentsCollection.add({
//         'service': service,
//         'date': date,
//         'time': time,
//         'comment': comment,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error saving appointment: $e");
//     }
//   }
// }

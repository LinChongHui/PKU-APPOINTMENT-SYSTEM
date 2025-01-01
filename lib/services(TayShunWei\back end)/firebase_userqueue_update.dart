import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  final CollectionReference _queueRef =
      FirebaseFirestore.instance.collection('queue');

  // Fetch the initial current number from Firestore
  Future<int?> getCurrentNumber() async {
    try {
      DocumentSnapshot snapshot = await _queueRef.doc('currentQueue').get();
      if (snapshot.exists) {
        return snapshot['currentNumber'] as int?;
      }
    } catch (e) {
      print('Error fetching current number: $e');
    }
    return null;
  }

  // Stream to listen for real-time updates to the current number
  Stream<int?> listenToCurrentNumber() {
    return _queueRef.doc('currentQueue').snapshots().map((event) {
      if (event.exists) {
        return event['currentNumber'] as int?;
      }
      return null;
    });
  }
}

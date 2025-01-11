import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  final CollectionReference _queueRef =
      FirebaseFirestore.instance.collection('queue');

  Future<void> updateCurrentNumber(int newNumber) async {
    try {
      await _queueRef.doc('currentQueue').set(
        {
          'currentNumber': newNumber,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error updating current number: $e');
      throw e;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  final CollectionReference _queueRef =
      FirebaseFirestore.instance.collection('queue');

  Future<void> updateCurrentNumber(int newNumber) async {
    try {
      await _queueRef.doc('currentQueue').set({
        'currentNumber': newNumber,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating current number: $e');
      throw e;
    }
  }

  // Add new functions to manage queue
  Future<void> removeFromQueue(int number) async {
    try {
      DocumentSnapshot doc = await _queueRef.doc('queueList').get();
      if (doc.exists) {
        List<dynamic> currentQueue = doc.get('numbers') ?? [];
        currentQueue.remove(number);
        await _queueRef.doc('queueList').set({'numbers': currentQueue});
      }
    } catch (e) {
      print('Error removing from queue: $e');
      throw e;
    }
  }

  Stream<int?> listenToCurrentNumber() {
    return _queueRef.doc('currentQueue').snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.get('currentNumber') as int?;
      }
      return null;
    });
  }

  Stream<List<int>> listenToQueue() {
    return _queueRef.doc('queueList').snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> numbers = snapshot.get('numbers') ?? [];
        return numbers.cast<int>().toList();
      }
      return <int>[];
    });
  }
}

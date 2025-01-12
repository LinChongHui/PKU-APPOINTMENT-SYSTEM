import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  final CollectionReference _queueRef =
      FirebaseFirestore.instance.collection('queue');

  Future<int?> getCurrentNumber() async {
    try {
      DocumentSnapshot snapshot = await _queueRef.doc('currentQueue').get();
      if (snapshot.exists) {
        return snapshot.get('currentNumber') as int?;
      }
    } catch (e) {
      print('Error fetching current number: $e');
    }
    return null;
  }

  Future<void> addToQueue(int number) async {
    try {
      DocumentSnapshot doc = await _queueRef.doc('queueList').get();
      List<dynamic> currentQueue = [];
      if (doc.exists) {
        currentQueue = doc.get('numbers') ?? [];
      }
      if (!currentQueue.contains(number)) {
        currentQueue.add(number);
        await _queueRef.doc('queueList').set({'numbers': currentQueue});
      } else {
        throw 'Number already in queue';
      }
    } catch (e) {
      print('Error adding to queue: $e');
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

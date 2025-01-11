import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveBMIData({
    required double height,
    required double weight,
    required int age,
    required double bmi,
    required String result,
  }) async {
    final User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).collection('bmi_records').add({
        'height': height,
        'weight': weight,
        'age': age,
        'bmi': bmi,
        'result': result,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchBMIRecords() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bmi_records')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }

    return [];
  }
}

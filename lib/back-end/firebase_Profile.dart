import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getCurrentUserID() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Stream<DocumentSnapshot> getUserProfileStream(String userID) {
    return _firestore.collection('users').doc(userID).snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getUserData(String userID) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userID).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  Future<void> updateUserData(String userID, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userID).update(data);
    } catch (e) {
      throw Exception("Error updating user data: $e");
    }
  }

  Future<String> uploadProfilePicture(String userID, File file) async {
    try {
      Reference ref = _storage.ref().child('profilePictures').child('$userID.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error uploading profile picture: $e");
    }
  }
}

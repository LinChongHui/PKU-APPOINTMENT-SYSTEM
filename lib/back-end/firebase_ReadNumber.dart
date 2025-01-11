import 'package:cloud_firestore/cloud_firestore.dart';

class ReadPhoneNum {
  // Private constructor to prevent instantiation
  ReadPhoneNum._();

  // Static instance to ensure single point of access
  static final ReadPhoneNum instance = ReadPhoneNum._();

  // Reference to the Firestore collection
  final CollectionReference _contactCollection = 
      FirebaseFirestore.instance.collection('PKU_contact_info');

  // Fetch phone number from Firestore
  Future<String> fetchPhoneNumber() async {
    try {
      // Using document with ID 'phone'
      DocumentSnapshot snapshot = await _contactCollection.doc('phone').get();
      
      // Check if document exists and has 'number' field
      if (snapshot.exists) {
        return snapshot.data() as String;
      }
      return '';
    } catch (error) {
      rethrow;
    }
  }

}
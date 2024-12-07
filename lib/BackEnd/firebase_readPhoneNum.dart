import 'package:cloud_firestore/cloud_firestore.dart';

class ReadPhoneNum {
  // Private constructor to prevent instantiation
  ReadPhoneNum._();

  // Static instance to ensure single point of access
  static final ReadPhoneNum instance = ReadPhoneNum._();

  // Reference to the phone number in Firebase Realtime Database
  final DatabaseReference _phoneNumberRef = 
      ReadPhoneNum.instance.reference().child('PKU_contact_info/phone_number');

  // Fetch phone number from Firebase
  Future<String> fetchPhoneNumber() async {
    try {
      DataSnapshot snapshot = await _phoneNumberRef.once();
      return snapshot.value?.toString() ?? '';
    } catch (error) {
      print('Error fetching phone number: $error');
      rethrow;
    }
  }
}

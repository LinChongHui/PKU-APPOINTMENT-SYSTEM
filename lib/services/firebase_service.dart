import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference servicesCollection =
      FirebaseFirestore.instance.collection('Service_list');

  Future<List<Map<String, String>>> fetchServices() async {
    try {
      QuerySnapshot snapshot = await servicesCollection.get();

      // Map the documents with null checking
      List<Map<String, String>> services = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Add null checking
        return {
          'name': data['Name']?.toString() ?? 'No Name',
          'description': data['Explanation']?.toString() ?? 'No Description',
        };
      }).toList();

      return services;
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
}

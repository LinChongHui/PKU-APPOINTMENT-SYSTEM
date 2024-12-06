import 'package:flutter/material.dart';
import 'package:appointment_system2/Widgets/appbar_and_backarrow.dart';
import 'package:appointment_system2/services/firebase_service.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  List<Map<String, String>> services =
      []; // List to hold services from Firestore
  List<Map<String, String>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterServices);
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      List<Map<String, String>> fetchedServices =
          await firebaseService.fetchServices();
      setState(() {
        services = fetchedServices;
        filteredServices = services; // Initialize with the full list
      });
      print(services);
    } catch (e) {
      print('Error loading services: $e');
      // You might also want to display an error message to the user
    }
  }

  void _filterServices() {
    setState(() {
      filteredServices = services
          .where((service) => service['name']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _showDetails(
      BuildContext context, String serviceName, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(serviceName),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: 'Service List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Service List
            Expanded(
              child: filteredServices.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        final serviceName = service['name']!;
                        final serviceDescription = service['description']!;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: const Icon(Icons.medical_services,
                                      size: 30, color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        serviceName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        serviceDescription,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    TextButton(
                                      onPressed: () => _showDetails(context,
                                          serviceName, serviceDescription),
                                      child: const Text('Details'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, serviceName);
                                      },
                                      child: const Text('Select'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child:
                          CircularProgressIndicator()), // Show loading indicator
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterServices);
    _searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/back-end/firebase_ServiceList.dart';

import 'Widget_inside_appbar_backarrow.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  List<Map<String, String>> services = [];
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
        filteredServices = services;
      });
    } catch (e) {
      print('Error loading services: $e');
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
            Expanded(
              child: filteredServices.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        final serviceName = service['name']!;
                        final serviceDescription = service['description']!;
                        final serviceImage =
                            service['imageUrl']!; // Get image URL from database

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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      serviceImage,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey[700],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    serviceName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      onPressed: () => _showDetails(context,
                                          serviceName, serviceDescription),
                                      child: Text(
                                        'Details',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: firstcolour,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, serviceName);
                                      },
                                      child: const Text('Select',
                                      style: TextStyle(color:fivethcolour),
                                      ),
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
                      child: CircularProgressIndicator(),
                    ),
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
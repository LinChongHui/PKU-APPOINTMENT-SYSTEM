import 'package:flutter/material.dart';
import 'package:appointment_system2/Widgets/appbar_and_backarrow.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> services = [
    'Service 1',
    'Service 2',
    'Service 3',
    'Service 4'
  ]; // List of service names
  final Map<String, String> serviceDetails = {
    'Service 1': 'Explanation for Service 1',
    'Service 2': 'Explanation for Service 2',
    'Service 3': 'Explanation for Service 3',
    'Service 4': 'Explanation for Service 4',
  }; // Explanations for each service

  late List<String> filteredServices;

  @override
  void initState() {
    super.initState();
    filteredServices = services;
    _searchController.addListener(_filterServices);
  }

  void _filterServices() {
    setState(() {
      filteredServices = services
          .where((service) => service
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _showDetails(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(serviceName),
          content: Text(serviceDetails[serviceName] ?? 'No details available'),
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
            // Search Field
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
              child: ListView.builder(
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final serviceName = filteredServices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Placeholder for Service Image
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[300], // Placeholder color
                            ),
                            child: const Icon(Icons.medical_services,
                                size: 30, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),

                          // Service Information
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  serviceDetails[serviceName] ??
                                      'No details available',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Action Buttons
                          Column(
                            children: [
                              TextButton(
                                onPressed: () =>
                                    _showDetails(context, serviceName),
                                child: const Text('Details'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                ),
                                onPressed: () {
                                  // Return the selected service name to the previous page
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

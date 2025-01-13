// lib/screens/admin_health_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:user_profile_management/back-end/firebase_HealthReport.dart';

class AdminHealthReportsScreen extends StatelessWidget {
  const AdminHealthReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Reports Admin'),
        backgroundColor: const Color(0xFF00897B),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              FirebaseFirestore.instance.collection('health_reports').get();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReportDialog(context),
        backgroundColor: const Color(0xFF00897B),
        child: const Icon(Icons.add),
      ),
      body: _buildReportsList(),
    );
  }

  Widget _buildReportsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('health_reports')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reports = snapshot.data?.docs ?? [];

        if (reports.isEmpty) {
          return const Center(
            child: Text(
              'No health reports found.\nClick the + button to add one.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final doc = reports[index];
            final data = doc.data() as Map<String, dynamic>;
            final report = HealthReport.fromMap(doc.id, data);

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Matric No: ${data['matricNumber'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF00897B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy').format(report.date),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color(0xFF00897B)),
                              onPressed: () => _showEditReportDialog(context, report, data['matricNumber']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReport(context, report.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      'Consultant: ${report.consultantName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.reportSummary,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

   Future<void> _showAddReportDialog(BuildContext context) async {
    final matricController = TextEditingController();
    final consultantController = TextEditingController();
    final summaryController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String? errorMessage;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Health Report'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: matricController,
                  decoration: InputDecoration(
                    labelText: 'Matric Number',
                    icon: const Icon(Icons.badge),
                    errorText: errorMessage,
                  ),
                  onChanged: (_) => setState(() => errorMessage = null),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                ),
                TextField(
                  controller: consultantController,
                  decoration: const InputDecoration(
                    labelText: 'Consultant Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: summaryController,
                  decoration: const InputDecoration(
                    labelText: 'Report Summary',
                    icon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate matric number
                try {
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .where('personalInfo.matricNumber', isEqualTo: matricController.text)
                      .get();

                  if (userDoc.docs.isEmpty) {
                    setState(() => errorMessage = 'Invalid matric number');
                    return;
                  }

                  if (consultantController.text.isEmpty ||
                      summaryController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('health_reports')
                      .add({
                    'matricNumber': matricController.text,
                    'date': selectedDate.toIso8601String(),
                    'consultantName': consultantController.text,
                    'reportSummary': summaryController.text,
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> _showEditReportDialog(
    BuildContext context,
    HealthReport report,
    String? matricNumber,
  ) async {
    final matricController = TextEditingController(text: matricNumber);
    final consultantController = TextEditingController(text: report.consultantName);
    final summaryController = TextEditingController(text: report.reportSummary);
    DateTime selectedDate = report.date;
    String? errorMessage;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Health Report'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
              ),
              TextField(
                controller: consultantController,
                decoration: const InputDecoration(
                  labelText: 'Consultant Name',
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: summaryController,
                decoration: const InputDecoration(
                  labelText: 'Report Summary',
                  icon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (consultantController.text.isEmpty ||
                  summaryController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance
                    .collection('health_reports')
                    .doc(report.id)
                    .update({
                  'date': selectedDate.toIso8601String(),
                  'consultantName': consultantController.text,
                  'reportSummary': summaryController.text,
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

   Future<void> _deleteReport(BuildContext context, String reportId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('health_reports')
            .doc(reportId)
            .delete();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting report: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
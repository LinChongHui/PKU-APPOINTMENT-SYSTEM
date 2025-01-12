import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Added import
import 'package:intl/intl.dart';
import 'package:user_profile_management/back-end/firebase_HealthReport.dart';

class UserHealthReportsScreen extends StatelessWidget {
  const UserHealthReportsScreen({super.key});

  // Get current user's matric number
  Future<String?> getCurrentUserMatricNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return null;

      final personalInfo = userDoc.data()?['personalInfo'] as Map<String, dynamic>?;
      return personalInfo?['matricNumber'] as String?;
    } catch (e) {
      print('Error fetching matric number: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Reports'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<String?>(
        future: getCurrentUserMatricNumber(),
        builder: (context, matricSnapshot) {
          if (matricSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (matricSnapshot.data == null) {
            return const Center(
              child: Text('Unable to fetch your student information'),
            );
          }

          return _buildReportsList(matricSnapshot.data!);
        },
      ),
    );
  }

  Widget _buildReportsList(String matricNumber) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('health_reports')
          .where('matricNumber', isEqualTo: matricNumber)  // Updated to use matricNumber
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final reports = snapshot.data?.docs ?? [];

        if (reports.isEmpty) {
          return const Center(
            child: Text(
              'No health reports available.',
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

            return _buildReportCard(report);
          },
        );
      },
    );
  }

  Widget _buildReportCard(HealthReport report) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.teal,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('MMMM dd, yyyy').format(report.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.teal,
                ),
                const SizedBox(width: 8),
                Text(
                  'Consultant: ${report.consultantName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              report.reportSummary,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildReportTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTags() {
    return Wrap(
      spacing: 8,
      children: [
        _buildTag('Health Record', Colors.blue),
        _buildTag('Consultation', Colors.green),
      ],
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.8),
          fontSize: 12,
        ),
      ),
    );
  }
}
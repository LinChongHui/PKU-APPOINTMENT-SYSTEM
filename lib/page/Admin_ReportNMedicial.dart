/*import 'package:flutter/material.dart';
import 'package:user_profile_management/page/Admin_HealthReportManagement.dart';
import 'package:user_profile_management/page/Admin_MedicalHistory.dart'; // Import the file for AdminHealthReportsScreen

class ReportNMedical extends StatelessWidget {
  const ReportNMedical({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminMedicalHistory(),
                  ),
                );*/
              },
              child: const Text('Go to Admin Medical History'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminHealthReportsScreen(),
                  ),
                );
              },
              child: const Text('Go to Admin Health Reports'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}*/

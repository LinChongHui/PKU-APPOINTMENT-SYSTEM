import 'package:flutter/material.dart';
import 'package:user_profile_management/page/Admin_EditMedicalRecord.dart';
import 'package:user_profile_management/page/Admin_HealthReportManagement.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/Widget_outside_appbar.dart';

class ReportNMedical extends StatelessWidget {
  const ReportNMedical({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: WidgetOutsideAppbar(title: 'Admin Panel', logoAsset: '',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.medical_services, size: 60, color: Colors.teal),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEditRecordForm(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Admin Medical History', style: TextStyle(fontSize: 16,color: fivethcolour)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.health_and_safety, size: 60, color: Colors.teal),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminHealthReportsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Admin Health Reports', style: TextStyle(fontSize: 16,color: fivethcolour)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

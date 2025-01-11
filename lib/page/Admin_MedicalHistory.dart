/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_profile_management/page/Admin_EditMedicalRecord.dart';
import 'package:user_profile_management/back-end/firebase_MedicalRecord.dart';
import 'package:user_profile_management/page/User_MedicalRecord.dart';

class AdminMedicalHistory extends StatefulWidget {
  const AdminMedicalHistory({super.key});

  @override
  _AdminMedicalHistoryState createState() => _AdminMedicalHistoryState();
}

class _AdminMedicalHistoryState extends State<AdminMedicalHistory> {
  final _recordService = MedicalRecordService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Medical History'),
      ),
      body: StreamBuilder<List<MedicalRecord>>(
        stream: _recordService.recordsStream,
        initialData: _recordService.getRecords(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(child: Text('No medical records found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                child: ListTile(
                  title:
                      Text(DateFormat('dd MMM yyyy').format(record.visitDate)),
                  subtitle: Text(record.reasons.join(', ')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditMedicalRecord(record: record),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _showDeleteConfirmation(context, record),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditMedicalRecord(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, MedicalRecord record) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Record'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _recordService.deleteRecord(record.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
*/
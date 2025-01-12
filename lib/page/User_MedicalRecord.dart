import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_profile_management/page/User_MedicalRecordService.dart';
import 'package:user_profile_management/back-end/firebase_MedicalRecord.dart';

class UserMedicalHistory extends StatelessWidget {
  final _recordService = MedicalRecordService();

  UserMedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        backgroundColor: Colors.teal,
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visit On',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM').format(record.visitDate),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        record.visitTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                      if (record.reasons.isNotEmpty) ...[
                        const Text(
                          'Reasons:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...record.reasons.map((reason) => Text('• $reason')),
                      ],
                      if (record.medicines.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Medicines:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...record.medicines.entries.map(
                          (entry) => Text('• ${entry.key}: ${entry.value}'),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        const Text('No medicines recorded'),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

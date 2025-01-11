import 'package:flutter/material.dart';

class UserInfoDisplay extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  final String userId;

  UserInfoDisplay({required this.userInfo, required this.userId});

  TableRow _buildInfoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var personalInfo = userInfo['personalInfo'] ?? {};
    var addressInfo = userInfo['addressInfo'] ?? {};
    var emergencyContact = userInfo['emergencyContact'] ?? {};

    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                '${personalInfo['firstName'] ?? ''} ${personalInfo['lastName'] ?? ''}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          
              const Divider(height: 20),

              // Personal Info
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildInfoRow('Email', personalInfo['email'] ?? ''),
                  _buildInfoRow('Matric', personalInfo['matricNumber'] ?? ''),
                  _buildInfoRow('IC/Passport', personalInfo['icPassport'] ?? ''),
                  _buildInfoRow('Mobile', personalInfo['mobile'] ?? ''),
                ],
              ),
              const SizedBox(height: 16),

              // Address Info
              const Text(
                'Resident Address',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildInfoRow('Kolej', addressInfo['kolej'] ?? ''),
                  _buildInfoRow('Block', addressInfo['block'] ?? ''),
                  _buildInfoRow('Room', addressInfo['roomNo'] ?? ''),
                ],
              ),
              const SizedBox(height: 16),

              // Emergency Contact
              const Text(
                'Emergency Contact',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildInfoRow('Name', emergencyContact['EmerCName'] ?? ''),
                  _buildInfoRow('Contact', emergencyContact['EmerCNo'] ?? ''),
                  _buildInfoRow('Relation', emergencyContact['EmerRelationship'] ?? ''),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

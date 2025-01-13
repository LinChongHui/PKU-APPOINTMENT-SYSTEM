import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_profile_management/back-end/firebase_MedicalRecord.dart';
import 'package:user_profile_management/page/Admin_EditMedicalRecord.dart';
import 'Widget_inside_appbar_backarrow.dart';

class UserRecordsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: 'Medical Record'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }

          String matricNumber = snapshot.data!['personalInfo']['matricNumber'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('medical_records')
                .where('matricNumber', isEqualTo: matricNumber)
                .orderBy('visitDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No medical records found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  var record = MedicalRecord.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  );

                  return Card(
                    child: ExpansionTile(
                      title: Text(
                        DateFormat('dd MMM yyyy').format(record.visitDate),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Time: ${record.time}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reasons:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...record.reasons.map((reason) => Padding(
                                    padding: const EdgeInsets.only(left: 16, top: 4),
                                    child: Text('• $reason'),
                                  )),
                              const SizedBox(height: 16),
                              const Text(
                                'Medicines:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...record.medicines.map((medicine) => Padding(
                                    padding: const EdgeInsets.only(left: 16, top: 4),
                                    child: Text(
                                      '• ${medicine.name} - ${medicine.dosage} (${medicine.frequency})',
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

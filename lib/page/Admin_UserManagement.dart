import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'User_info_display.dart'; // Import the UserInfoDisplay widget
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/Widget_outside_appbar.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({Key? key}) : super(key: key);

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: WidgetOutsideAppbar(title: 'User Management', logoAsset: '',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Action')),
                ],
                rows: users.map((user) {
                  final uid = user.id;
                  final personalInfo = user.data() as Map<String, dynamic>?; // Getting personal information
                  final firstName = personalInfo?['personalInfo']['firstName'] ?? 'N/A';
                  final lastName = personalInfo?['personalInfo']['lastName'] ?? 'N/A';
                  //final role = personalInfo?['role'] ?? 'N/A';

                  return DataRow(cells: [
                    DataCell(Text(firstName)),
                    DataCell(Text(lastName)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.info, color: Colors.green),
                            onPressed: () {
                              _showInfoDialog(context, personalInfo, uid);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: sixthcolour),
                            onPressed: () {
                              _showUpdateDialog(context, uid, firstName, lastName);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: fourthcolour),
                            onPressed: () async {
                              final confirm = await _showDeleteConfirmationDialog(context);
                              if (confirm == true) {
                                FirebaseFirestore.instance.collection('users').doc(uid).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User deleted successfully!')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(BuildContext context, Map<String, dynamic>? userInfo, String userId) async {
    final personalInfo = userInfo?['personalInfo'] ?? {};
    final addressInfo = userInfo?['addressInfo'] ?? {};
    final emergencyContact = userInfo?['emergencyContact'] ?? {};
    final role = userInfo?['role'] ?? 'N/A';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Information:'),
          content: UserInfoDisplay(
            userInfo: {
              'personalInfo': personalInfo,
              'addressInfo': addressInfo,
              'emergencyContact': emergencyContact,
              'role': role,
            },
            userId: userId,
          ),
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

  Future<void> _showUpdateDialog(BuildContext context, String userId, String firstName, String lastName) async {
    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedFirstName = firstNameController.text.trim();
                final updatedLastName = lastNameController.text.trim();

                if (updatedFirstName.isNotEmpty && updatedLastName.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'personalInfo.firstName': updatedFirstName,
                    'personalInfo.lastName': updatedLastName,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User updated successfully!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

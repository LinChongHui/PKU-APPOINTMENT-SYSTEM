import 'package:flutter/material.dart';
import 'package:user_profile_management/back-end/firebase_Profile.dart';
import 'User_EditProfile.dart';
import 'package:user_profile_management/page/Widget_outside_appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  String? userID;
  bool _isLoading = true;

  // User Data Variables
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    try {
      userID = await _profileService.getCurrentUserID();
      if (userID != null) {
        _setupUserListener();
      } else {
        setState(() {
          _isLoading = false;
          userData['matricNumber'] = "No user logged in";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        userData['matricNumber'] = "Error initializing profile";
      });
    }
  }

  void _setupUserListener() {
    _profileService.getUserProfileStream(userID!).listen(
      (snapshot) {
        if (snapshot.exists) {
          setState(() {
            userData = snapshot.data() as Map<String, dynamic>;
            _isLoading = false;
          });
        } else {
          setState(() {
            userData = {'firstName': "User Not Found"};
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          userData = {'firstName': "Error fetching data"};
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: WidgetOutsideAppbar(title: 'Profile', logoAsset: '',),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture and Name Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/736x/90/d1/ac/90d1ac48711f63c6a290238c8382632f.jpg',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${userData['personalInfo']?['firstName'] ?? '-'} ${userData['personalInfo']?['lastName'] ?? '-'}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userData['personalInfo']?['matricNumber'] ?? '-',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Personal Information Section
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoRow(
                      icon: Icons.perm_identity,
                      label: 'IC/Passport',
                      value: userData['personalInfo']?['icPassport'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: userData['personalInfo']?['email'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Date of Birth',
                      value: userData['personalInfo']?['dateOfBirth'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.phone,
                      label: 'Contact Number',
                      value: userData['personalInfo']?['mobile'] ?? '-',
                    ),
                  ],
                ),
              ),
            ),

            // Address Information Section
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoRow(
                      icon: Icons.home,
                      label: 'Block',
                      value: userData['addressInfo']?['block'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.location_city,
                      label: 'Kolej',
                      value: userData['addressInfo']?['kolej'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.meeting_room,
                      label: 'Room Number',
                      value: userData['addressInfo']?['roomNo'] ?? '-',
                    ),
                  ],
                ),
              ),
            ),

            // Emergency Contact Section
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoRow(
                      icon: Icons.contact_page,
                      label: 'Name',
                      value: userData['emergencyContact']?['name'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.phone,
                      label: 'Contact Number',
                      value: userData['emergencyContact']?['number'] ?? '-',
                    ),
                    InfoRow(
                      icon: Icons.family_restroom,
                      label: 'Relationship',
                      value: userData['emergencyContact']?['relationship'] ?? '-',
                    ),
                  ],
                ),
              ),
            ),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(userID: userID ?? ''),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/User_BookingAppoitnment.dart';
import 'package:user_profile_management/page/User_AppointmentList.dart';
import 'package:user_profile_management/page/User_LiveQueue_user.dart';
import 'package:user_profile_management/page/User_MedicalRecord.dart';
import 'package:user_profile_management/page/User_LocationDistress.dart';
import 'package:user_profile_management/page/Widget_outside_appbar.dart';
import 'package:user_profile_management/page/User_HealthReport.dart';
import 'package:user_profile_management/back-end/firebase_ReadNumber.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _showConfirm = false;
  String _phoneNum = "";
  final ReadPhoneNum _readPhoneNum = ReadPhoneNum.instance;

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
  }

  void _fetchPhoneNumber() async {
    try {
      final phoneNumber = await _readPhoneNum.fetchPhoneNumber();
      setState(() {
        _phoneNum = phoneNumber;
      });
    } catch (error) {
      _showErrorSnackBar('Failed to fetch phone number');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void executePhoneCall() async {
    final url = Uri(scheme: 'tel', path: _phoneNum);

    if(await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    }
    else {
      print("Could not launch phone call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: WidgetOutsideAppbar(title: 'PKU', logoAsset: 'assets/newlogo.png',),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildGridItem(
                  context,
                  Icons.calendar_today,
                  'Book An Appointment',
                  const AppointmentPage(),
                ),
                _buildGridItem(
                  context,
                  Icons.assignment,
                  'Appointment Record',
                  const AppointmentHistoryScreen(),
                ),
                _buildGridItem(
                  context,
                  Icons.location_on,
                  'Location Targeting',
                  const LocationMapPage(),
                ),
                _buildGridItem(
                  context,
                  Icons.live_tv,
                  'Live Queue',
                  UserScreen(),
                ),
                _buildGridItem(
                  context,
                  Icons.health_and_safety,
                  'Health Records',
                  const UserMedicalrecord(),
                ),
                _buildGridItem(
                  context,
                  Icons.medical_information,
                  'Medical Records',
                  UserRecordsView(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Image.asset(
                          'assets/hometab1.jpg',
                          width: constraints.maxWidth * 1,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome to PKU UTM! Your health, our priority.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (_showConfirm)
            Positioned(
              right: 80,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Are you sure you want to make a phone call?'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showConfirm = false;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            executePhoneCall();
                            setState(() {
                              _showConfirm = false;
                            });
                          },
                          child: const Text('Call'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showConfirm = true;
                });
              },
              child: 
              const Icon(Icons.phone,color: fivethcolour),
              backgroundColor: firstcolour,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: firstcolour),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

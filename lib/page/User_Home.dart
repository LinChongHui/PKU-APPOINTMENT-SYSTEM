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
import 'package:user_profile_management/page/User_MedicalRecord.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {// Returns null if the user is not logged in
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
                  const UserHealthReportsScreen(),
                ),
                _buildGridItem(
                  context,
                  Icons.medical_information,
                  'Medical Records',
                  //const AppointmentHistoryScreen(),
                  UserMedicalHistory(),
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

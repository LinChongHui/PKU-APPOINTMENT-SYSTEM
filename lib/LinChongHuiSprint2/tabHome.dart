import 'package:flutter/material.dart';
import 'package:user_profile_management/const/theme.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // clear the arrow back
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/newlogo.png', height: 30), // Replace with your logo path
            const SizedBox(width: 25),
            const Text(
              'PKU APPOINTMENT SYSTEM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
                  Icons.calendar_today,
                  'Book An Appointment',
                  BookAppointmentButton(),
                ),
                _buildGridItem(
                  Icons.assignment,
                  'Appointment Record',
                  AppointmentRecordButton(),
                ),
                _buildGridItem(
                  Icons.location_on,
                  'Location Targeting',
                  LocationTargetingButton(),
                ),
                _buildGridItem(
                  Icons.health_and_safety,
                  'Health Reports',
                  HealthReportsButton(),
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
                          width: constraints.maxWidth * 1, // Fit to 80% of available width
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

  Widget _buildGridItem(IconData icon, String title, Widget destination) {
    return GestureDetector(
      onTap: () {
        // Navigate to the destination page
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: primaryColor),
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

// Placeholder widgets for navigation targets
class BookAppointmentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AppointmentRecordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LocationTargetingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HealthReportsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

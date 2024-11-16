import 'package:flutter/material.dart';
import 'package:user_profile_management/const/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Open drawer or handle menu actions
          },
        ),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30), // Replace with your logo path
            const SizedBox(width: 20),
            const Text(
              'Pusat Kesihatan UTM',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Image Slider
          Container(
            height: 180,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                Image.asset('assets/home1.jpg', fit: BoxFit.cover),
                Image.asset('assets/home2.jpg', fit: BoxFit.cover),
                Image.asset('assets/home3.jpg', fit: BoxFit.cover),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => _buildIndicator(index == _currentPage),
            ),
          ),
          const SizedBox(height: 20),
          // Menu Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildGridItem(Icons.calendar_today, 'Book An Appointment', const BookAppointmentPage()),
                _buildGridItem(Icons.assignment, 'Appointment Record', const AppointmentRecordPage()),
                _buildGridItem(Icons.location_on, 'Location Targeting', const LocationTargetingPage()),
                _buildGridItem(Icons.health_and_safety, 'Health Reports', const HealthReportsPage()),
                _buildGridItem(Icons.settings, 'Settings', const SettingsPage()),
                _buildGridItem(Icons.logout, 'Logout', const LogoutPage()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Active tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 16.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages
class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book An Appointment')),
      body: const Center(child: Text('Book An Appointment Page')),
    );
  }
}

class AppointmentRecordPage extends StatelessWidget {
  const AppointmentRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Record')),
      body: const Center(child: Text('Appointment Record Page')),
    );
  }
}

class LocationTargetingPage extends StatelessWidget {
  const LocationTargetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Targeting')),
      body: const Center(child: Text('Location Targeting Page')),
    );
  }
}

class HealthReportsPage extends StatelessWidget {
  const HealthReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Reports')),
      body: const Center(child: Text('Health Reports Page')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: const Center(child: Text('You have been logged out.')),
    );
  }
}

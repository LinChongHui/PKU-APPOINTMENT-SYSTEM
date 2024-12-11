//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_profile_management/const/theme.dart';
//import 'package:user_profile_management/page/login.dart';
//import 'package:user_profile_management/page/logout.dart';
import 'package:user_profile_management/page/tabProfile.dart';
import 'package:user_profile_management/page/test.dart';
import 'package:user_profile_management/page/tabSetting.dart';
import 'package:user_profile_management/page/tabHome.dart';
import 'package:user_profile_management/page/tabHealthRport.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFABOptions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildHomeTab(),
              _buildHealthRecordsTab(),
              _buildProfileTab(),
              _buildSettingsTab(),
            ],
          ),
          if (_showFABOptions)
            Positioned(
              right: 16,
              bottom: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildFABOption(
                    icon: Icons.location_on,
                    label: 'Locate',
                    onTap: () {
                      setState(() => _showFABOptions = false);
                      print("Locate button pressed");
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildFABOption(
                    icon: Icons.call,
                    label: 'Emergency Call',
                    onTap: () {
                      setState(() => _showFABOptions = false);
                      //_makeEmergencyCall();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Material(
        color: primaryColor,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(
            height: 1.8,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.book_sharp), text: 'Health Records'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showFABOptions = !_showFABOptions;
          });
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

    // Home Tab content
  Widget _buildHomeTab() {
    return HomeTab();
  }

  // Profile Tab content
  Widget _buildProfileTab() {
    //return const Center(child: Text("Hihi"));
    return ProfilePage() ;
  }

  Widget _buildHealthRecordsTab(){
    //return const Center(child: Text('Health Records'));
    return HealthRecordPage();
  }

  // Settings Tab content
  Widget _buildSettingsTab() {
//    return const Center(child: Text('Settings Tab Content'));
    return SettingsPage();
  }
  Widget _buildFABOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Future<void> _makeEmergencyCall() async {
    const phoneNumber = 'tel:999'; // Emergency number
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not make the call")),
      );
    }
  }*/
}

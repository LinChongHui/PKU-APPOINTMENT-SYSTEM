import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/User_Profile.dart';
import 'package:user_profile_management/page/User_Setting.dart';
import 'package:user_profile_management/page/User_Home.dart';
import 'package:user_profile_management/page/Admin_UserManagement.dart';
import 'package:user_profile_management/page/User_HealthAnalytics.dart';
import 'package:user_profile_management/page/Admin_LiveQueueManagement.dart';
import 'package:user_profile_management/page/Admin_LocationDistress.dart';
import 'package:user_profile_management/page/User_EmergencyCall.dart';
import 'package:user_profile_management/page/Admin_ReportNMedicial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFABOptions = false;
  bool _isAdmin = false;
  bool _isLoading = true;
  final Map<int, Widget> _cachedTabs = {};
  late Stream<DocumentSnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeUserStream();
  }

  void _initializeUserStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots();

      _userStream.listen((snapshot) {
        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final bool isAdmin = userData['role'] == 'admin';

          if (isAdmin != _isAdmin || _isLoading) {
            setState(() {
              _isAdmin = isAdmin;
              if (_isAdmin != isAdmin) {
                _cachedTabs.clear(); // Clear cache when role changes
                _tabController.dispose();
                _tabController = TabController(
                  length: isAdmin ? 5 : 4,
                  vsync: this,
                );
              }
              _isLoading = false;
            });
          }
        }
      });
    }
  }

  Widget _getCachedTab(int index, Widget Function() builder) {
    return _cachedTabs.putIfAbsent(index, builder);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cachedTabs.clear();
    super.dispose();
  }

  Widget _buildShimmerLoading() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          // Header shimmer
          Container(
            height: 200,
            color: Colors.grey[200],
            margin: const EdgeInsets.all(16),
          ),
          // Content shimmer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                3,
                (index) => Container(
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: _buildShimmerLoading(),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: _isAdmin ? _buildAdminTabs() : _buildUserTabs(),
          ),
          if (_showFABOptions && !_isAdmin)
            Positioned(
              right: 16,
              bottom: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildFABOption(
                    icon: Icons.call,
                    label: 'Emergency Call',
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmergencyCall()),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Material(
        color: firstcolour,
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
          tabs: _isAdmin ? _buildAdminTabIcons() : _buildUserTabIcons(),
        ),
      ),
      floatingActionButton: !_isAdmin
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showFABOptions = !_showFABOptions;
                });
              },
              backgroundColor: firstcolour,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  List<Widget> _buildUserTabs() {
    return [
      _getCachedTab(0, () => const HomeTab()),
      _getCachedTab(1, () => const HealthAnalytics()),
      _getCachedTab(2, () => const ProfilePage()),
      _getCachedTab(3, () => const SettingsPage()),
    ];
  }

  List<Widget> _buildAdminTabs() {
    return [
      _getCachedTab(0, () => AdminScreen()),
      _getCachedTab(1, () => const AdminUserManagement()),
      //_getCachedTab(2, () => const ReportNMedical()),
      _getCachedTab(2, () => const Center()),
      _getCachedTab(3, () => const AdminMapPage()),
      _getCachedTab(4, () => const SettingsPage()),
    ];
  }

  List<Widget> _buildUserTabIcons() {
    return const [
      Tab(icon: Icon(Icons.home), text: 'Home'),
      Tab(icon: Icon(Icons.book_sharp), text: 'Health Analysis'),
      Tab(icon: Icon(Icons.person), text: 'Profile'),
      Tab(icon: Icon(Icons.settings), text: 'Settings'),
    ];
  }

  List<Widget> _buildAdminTabIcons() {
    return const [
      Tab(icon: Icon(Icons.dashboard), text: 'Appointment'),
      Tab(icon: Icon(Icons.people), text: 'Users'),
      Tab(icon: Icon(Icons.analytics), text: 'Reports'),
      Tab(icon: Icon(Icons.location_city), text: 'Location'),
      Tab(icon: Icon(Icons.settings), text: 'Settings'),
    ];
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
            Icon(icon, color: firstcolour),
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
}
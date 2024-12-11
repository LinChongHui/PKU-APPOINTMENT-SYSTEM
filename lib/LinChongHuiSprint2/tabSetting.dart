import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_profile_management/const/theme.dart';
import 'package:user_profile_management/page/PrivacyPolicy.dart';
import 'package:user_profile_management/page/logout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // clear the arrow back
        title: const Text(
              'Setting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Privacy Policy
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.teal),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context, 
                MaterialPageRoute(
                  builder:(context) => const PrivacyPolicyPage(),
                )
                );
              },
            ),
            const Divider(),

            // Terms & Conditions
            ListTile(
              leading: const Icon(Icons.description, color: Colors.teal),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                 Navigator.push(
                  context, 
                MaterialPageRoute(
                  builder:(context) => const PrivacyPolicyPage(),
                )
                );
              },
            ),
            const Divider(),

            // Help & Support
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.teal),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context, 
                MaterialPageRoute(
                  builder:(context) => const PrivacyPolicyPage(),
                )
                );
              },
            ),
            const Divider(),

            // Help & Support
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context, 
                MaterialPageRoute(
                  builder:(context) => const LogoutPage(),
                )
                );
              },
            ),

            const Divider(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

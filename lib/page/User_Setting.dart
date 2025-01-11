import 'package:flutter/material.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_profile_management/page/Interface.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsOptions = [
      _SettingOption(
        icon: Icons.privacy_tip,
        title: 'Privacy Policy',
        page: const _InfoPage(
          title: 'Privacy Policy',
          content: 'Privacy Policy:\n\n1. Data Collection: We collect personal data only when necessary.\n'
              '2. Data Use: Personal data is used solely for application purposes.\n'
              '3. Data Security: We implement strong security measures to protect your data.',
        ),
      ),
      _SettingOption(
        icon: Icons.description,
        title: 'Terms & Conditions',
        page: const _InfoPage(
          title: 'Terms & Conditions',
          content: 'Terms & Conditions:\n\n1. Acceptance: Use of the app constitutes acceptance of these terms.\n'
              '2. User Responsibilities: Users must provide accurate information.\n'
              '3. Liability: The app is not liable for data breaches beyond its control.',
        ),
      ),
      _SettingOption(
        icon: Icons.help_outline,
        title: 'Help & Support',
        page: const _HelpSupportPage(),
      ),
      _SettingOption(
        icon: Icons.logout,
        title: 'Logout',
        action: (context) => _logout(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Setting', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: firstcolour,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: settingsOptions.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final option = settingsOptions[index];
          return ListTile(
            leading: Icon(option.icon, color: Colors.teal),
            title: Text(option.title),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => option.navigate(context),
          );
        },
      ),
    );
  }
}

class _SettingOption {
  final IconData icon;
  final String title;
  final Widget? page;
  final void Function(BuildContext)? action;

  _SettingOption({required this.icon, required this.title, this.page, this.action});

  void navigate(BuildContext context) {
    if (action != null) {
      action!(context);
    } else if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }
}

class _InfoPage extends StatelessWidget {
  final String title;
  final String content;

  const _InfoPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: firstcolour,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 2, blurRadius: 5)],
          ),
          child: Text(content, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

class _HelpSupportPage extends StatelessWidget {
  const _HelpSupportPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: firstcolour,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 2, blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('How can we help you?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('For assistance, contact support@pkuapp.com.'),
            ],
          ),
        ),
      ),
    );
  }
}

void _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const InterfacePage()),
  );
}

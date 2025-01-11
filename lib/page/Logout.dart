import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'Interface.dart';  // Import the interface.dart file

void logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();  // Sign out the user
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => InterfacePage()),  // Navigate to InterfacePage
  );
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform the logout actions here
            // For example, Firebase sign-out or clearing user data

            // After logging out, navigate to the InterfacePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InterfacePage()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}




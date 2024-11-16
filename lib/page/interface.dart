import 'package:flutter/material.dart';
import 'package:user_profile_management/const/theme.dart';
import 'package:user_profile_management/page/login.dart';
import 'package:user_profile_management/page/registration.dart';

class InterfacePage extends StatelessWidget {
  const InterfacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset( 'assets/logo.png', height: 150,),
            const SizedBox(height: 20),

            // Title and Subtitle
            const Text(
              'Pusat Kesihatan UTM',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: secondaryColor, // Custom color
              ),
            ),
            const Text(
              'A  U  T  O  M  A  N  A  G  E  R',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2.0,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 50),

            // Registration Button
            SizedBox(
              width: 200, // Set a fixed width to make both buttons the same size
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding only
                ),
                child: const Text(
                  'Registration',
                  style: TextStyle(fontSize: 18, color: tertiaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Log In Button
            SizedBox(
              width: 200, // Set the same fixed width to match the Registration button
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding only
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18, color: tertiaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

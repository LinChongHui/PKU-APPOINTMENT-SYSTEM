import 'package:appointment_system2/Screen/AppointmentPage.dart';
import 'package:appointment_system2/Screen/AvailableDatesPage.dart';
import 'package:appointment_system2/Screen/ServiceListPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment System',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AppointmentPage(), // Start with the AppointmentPage
      routes: {
        '/serviceList': (context) => const ServiceListPage(),
        '/availableDates': (context) => const AvailableDatesPage(),
      },
    );
  }
}

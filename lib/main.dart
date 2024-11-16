import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_profile_management/page/interface.dart';
import 'page/home.dart';
import 'const/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: InterfacePage(),
      home:HomePage(), // test for homepage()
    );
  }
}

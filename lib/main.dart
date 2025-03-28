import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_profile_management/page/Interface.dart';
import 'package:user_profile_management/page/User_Profile.dart';
import 'page/Home.dart';
import 'package:user_profile_management/page/Admin_UserManagement.dart';
import 'back-end/firebase_options.dart';
//import 'package:user_profile_management/page/Admin_MedicalRecord.dart';
import 'package:user_profile_management/page/Admin_EditMedicalRecord.dart';

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
      //home:AdminUserManagement(),
      //home:AddMedicalRecord(),
    );
  }
}

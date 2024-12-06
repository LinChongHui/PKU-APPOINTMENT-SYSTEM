import 'package:flutter/material.dart';
import 'package:appointment_system2/const/colour.dart';

// ignore: camel_case_types
class AppBarAndBackArrow extends StatelessWidget {
  final String title;

  const AppBarAndBackArrow({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Transform.translate(
        offset: const Offset(-50, 0), // Adjust the offset value to move left
        child: Text(
          title, // Use the title parameter here
          style: const TextStyle(
            color: fivethcolour,
          ),
        ),
      ),
      backgroundColor: firstcolour,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: thirdcolour),
        onPressed: () => Navigator.pop(context), // Pop to go back
      ),
    );
  }
}

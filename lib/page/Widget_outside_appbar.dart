import 'package:flutter/material.dart';
import 'package:user_profile_management/page/Theme.dart';

class WidgetOutsideAppbar extends StatelessWidget {
  final String title;
  final String logoAsset;

  const WidgetOutsideAppbar({
    super.key,
    required this.title,
    required this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Disable back arrow
      backgroundColor: firstcolour,
      centerTitle: false, // Align title to start
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (logoAsset.isNotEmpty) ...[
            Image.asset(
              logoAsset,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
          ],
          Text(
            title,
            style: const TextStyle(
              color: fivethcolour,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
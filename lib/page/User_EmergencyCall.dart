import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:user_profile_management/back-end/firebase_ReadNumber.dart';
import 'package:user_profile_management/page/Widget_inside_appbar_backarrow.dart';

class EmergencyCall extends StatefulWidget {
  const EmergencyCall({super.key});

  @override
  State<EmergencyCall> createState() => _EmergencyCall();
}

class _EmergencyCall extends State<EmergencyCall> {
  bool _showConfirm = false;
  String _phoneNum = "";
  final ReadPhoneNum _readPhoneNum = ReadPhoneNum.instance;

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
  }

  void _fetchPhoneNumber() async {
    try {
      final phoneNumber = await _readPhoneNum.fetchPhoneNumber();
      setState(() {
        _phoneNum = phoneNumber;
      });
    } catch (error) {
      _showErrorSnackBar('Failed to fetch phone number');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void executePhoneCall() async {
    final url = Uri(scheme: 'tel', path: _phoneNum);

    if(await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    }
    else {
      log("Could not launch phone call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: 'Emergency'),
      ),
      
      floatingActionButton: Stack(
        children: [
          if (_showConfirm)
            Positioned(
              right: 80,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Are you sure you want to make a phone call?'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showConfirm = false;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            executePhoneCall();
                            setState(() {
                              _showConfirm = false;
                            });
                          },
                          child: const Text('Call'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _showConfirm = true;
                  });
                },
                child: const Icon(Icons.phone),
              ),
            ),
        ],
      ),
    );
  }
}
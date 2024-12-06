import 'package:appointment_system2/Widgets/appbar_and_backarrow.dart';
import 'package:appointment_system2/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appointment_system2/services/firebase_Appointmentpage.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? selectedService;
  String? selectedDate;
  String? selectedTime;
  final TextEditingController _commentController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: 'Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              text: selectedService ?? 'Select a Service',
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/serviceList');
                if (result != null) {
                  setState(() {
                    selectedService = result as String;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: selectedDate != null && selectedTime != null
                  ? '$selectedDate, $selectedTime'
                  : 'Available Dates',
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/availableDates');
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    selectedDate =
                        DateFormat('yyyy-MM-dd').format(result['date']);
                    selectedTime = result['time'];
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                if (selectedService != null &&
                    selectedDate != null &&
                    selectedTime != null &&
                    _commentController.text.isNotEmpty) {
                  print(
                      "Service: $selectedService, Date: $selectedDate, Time: $selectedTime, Comment: ${_commentController.text}"); // Debug print

                  // Call the backend function to create the appointment
                  await _firebaseService.createAppointment(
                    selectedService!,
                    selectedDate!,
                    selectedTime!,
                    _commentController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Appointment added successfully")),
                  );

                  // Navigate back to the homepage and clear the navigation stack
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/homepage', (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

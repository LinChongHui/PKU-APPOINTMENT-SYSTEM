import 'package:appointment_system2/Widgets/appbar_and_backarrow.dart';
import 'package:appointment_system2/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? selectedService;
  String? selectedDate;
  String? selectedTime;

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
            // Select a Service Button with Forward Arrow
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

            // Available Dates Button with Forward Arrow
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

            // Comment Text Field
            const TextField(
              decoration: InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),

            // Submit Button
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Handle submit action here, like saving data or performing an action
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

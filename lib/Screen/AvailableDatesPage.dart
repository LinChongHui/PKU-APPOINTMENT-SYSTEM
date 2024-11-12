import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appointment_system2/services/firebase_availableDates.dart';
import 'package:appointment_system2/widgets/appbar_and_backarrow.dart';

class AvailableDatesPage extends StatefulWidget {
  const AvailableDatesPage({Key? key}) : super(key: key);

  @override
  _AvailableDatesPageState createState() => _AvailableDatesPageState();
}

class _AvailableDatesPageState extends State<AvailableDatesPage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  List<String> _timeSlots = [];
  final AppointmentFirebaseService _appointmentService =
      AppointmentFirebaseService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent selecting past dates
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = null; // Reset the time slot when date changes
        _fetchTimeSlots(pickedDate);
      });
    }
  }

  Future<void> _fetchTimeSlots(DateTime date) async {
    try {
      _timeSlots = await _appointmentService.getTimeSlots(date);
      setState(() {});
    } catch (e) {
      print('Error fetching time slots: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch time slots.')),
      );
    }
  }

  void _confirmSelection() {
    if (_selectedDate != null && _selectedTime != null) {
      Navigator.pop(context, {'date': _selectedDate, 'time': _selectedTime});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a date and time.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: 'Select Date & Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Display and Picker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _selectedDate == null
                        ? 'Select a Date'
                        : DateFormat('EEE, MMM d, yyyy').format(_selectedDate!),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slots
            if (_selectedDate != null) ...[
              const Text(
                'Available Time Slots',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _timeSlots.isEmpty
                  ? const Text('No time slots available for this date.')
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _timeSlots.map((time) {
                        return ChoiceChip(
                          label: Text(time),
                          selected: _selectedTime == time,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedTime = selected ? time : null;
                            });
                          },
                          selectedColor: Colors.teal,
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            color: _selectedTime == time
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 20),
            ],

            // Confirm and Clear Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  onPressed: _confirmSelection,
                  child: const Text('Confirm', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Clear', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

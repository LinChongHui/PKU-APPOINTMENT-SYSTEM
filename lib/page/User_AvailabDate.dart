import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/back-end/firebase_AvailableDate.dart';

import 'Widget_inside_appbar_backarrow.dart';

class AvailableDatesPage extends StatefulWidget {
  const AvailableDatesPage({Key? key}) : super(key: key);

  @override
  _AvailableDatesPageState createState() => _AvailableDatesPageState();
}

class _AvailableDatesPageState extends State<AvailableDatesPage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  List<String> _timeSlots = [];
  bool _isLoading = false;
  final AppointmentFirebaseService _appointmentService =
      AppointmentFirebaseService();

  Future<void> _selectDate(BuildContext context) async {
    try {
      final now = DateTime.now();
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 1),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = null;
          _isLoading = true;
        });
        await _fetchTimeSlots(pickedDate);
      }
    } catch (e) {
      _showError('Failed to select date. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchTimeSlots(DateTime date) async {
    try {
      final slots = await _appointmentService.getTimeSlots(date);
      setState(() => _timeSlots = slots);
    } catch (e) {
      _showError('Failed to fetch time slots.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: fourthcolour,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmSelection() {
    if (_selectedDate == null || _selectedTime == null) {
      _showError('Please select both date and time.');
      return;
    }
    Navigator.pop(context, {
      'date': _selectedDate,
      'time': _selectedTime,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: '      Select Appointment'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDateSelector(),
              if (_selectedDate != null) ...[
                const SizedBox(height: 24),
                _buildTimeSlots(),
              ],
              const Spacer(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                _selectedDate == null
                    ? 'Select Date'
                    : DateFormat('EEEE, MMMM d, y').format(_selectedDate!),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_timeSlots.isEmpty)
          const Center(
            child: Text(
              'No available slots for this date',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeSlots.map((time) => _buildTimeChip(time)).toList(),
          ),
      ],
    );
  }

  Widget _buildTimeChip(String time) {
    final isSelected = _selectedTime == time;
    return FilterChip(
      label: Text(time),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedTime = selected ? time : null);
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: fourthcolour,
                foregroundColor: fivethcolour,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Confirm',
              style: TextStyle(color: fivethcolour),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:appointment_system2/services/firebase_update_queue(admin).dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _currentNumberController =
      TextEditingController();
  final QueueService _queueService = QueueService(); // Instance of the service

  void _updateCurrentNumber() async {
    if (_currentNumberController.text.isNotEmpty) {
      int newNumber = int.parse(_currentNumberController.text);

      try {
        await _queueService.updateCurrentNumber(newNumber);
        _currentNumberController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Current number updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update current number')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white), // Back arrow color
        title: Text(
          'Live Queue',
          style: TextStyle(color: Colors.white), // Title color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Current Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateCurrentNumber,
              child: Text('Update Current Number'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}

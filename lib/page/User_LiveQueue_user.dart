import 'package:flutter/material.dart';
import 'package:user_profile_management/back-end/firebase_UserLiveQueue.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final QueueService _queueService = QueueService(); // Instance of the service
  final TextEditingController _userNumberController = TextEditingController();

  int? _currentNumber;
  int? _userNumber;
  int _numbersLeft = 0;
  bool _showInfo = false;
  bool _numberPassed = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialCurrentNumber();
    _listenToQueueUpdates();
  }

  // Fetch the current number when the screen loads
  void _fetchInitialCurrentNumber() async {
    int? currentNumber = await _queueService.getCurrentNumber();
    setState(() {
      _currentNumber = currentNumber;
    });
  }

  // Listen to real-time updates for the current number
  void _listenToQueueUpdates() {
    _queueService.listenToCurrentNumber().listen((currentNumber) {
      setState(() {
        _currentNumber = currentNumber;
        if (_userNumber != null && _currentNumber != null && !_numberPassed) {
          _numbersLeft =
              (_userNumber! - _currentNumber!).clamp(0, _userNumber!);
        }
      });
    });
  }

  // Handle user number submission
  void _updateUserNumber() {
    if (_userNumberController.text.isNotEmpty) {
      int enteredNumber = int.parse(_userNumberController.text);

      if (_currentNumber != null) {
        if (enteredNumber < _currentNumber!) {
          // Case: Entered number has already passed
          setState(() {
            _numberPassed = true;
            _showInfo = false;
            _userNumber = enteredNumber;
          });
          _userNumberController.clear();
          return;
        } else {
          // Case: Entered number is higher than the current number
          setState(() {
            _userNumber = enteredNumber;
            _numbersLeft =
                (_userNumber! - _currentNumber!).clamp(0, _userNumber!);
            _showInfo = true;
            _numberPassed = false;
          });
          _userNumberController.clear();
          return;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter your token number"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Live Queue',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Your Token Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateUserNumber,
              child: Text('Submit Your Number'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            SizedBox(height: 20),

            // Case 1: Entered number is higher than the current number
            if (_showInfo && _currentNumber != null && _userNumber != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Live Queue Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Current Number Being Served: $_currentNumber',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your Number: $_userNumber',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Numbers Left: $_numbersLeft',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Case 2: Entered number has already passed
            if (_numberPassed && _currentNumber != null && _userNumber != null)
              Card(
                elevation: 4,
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Queue Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Current Number Being Served: $_currentNumber',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your Number ($_userNumber) has already passed.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

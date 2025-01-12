import 'package:flutter/material.dart';
import 'package:user_profile_management/back-end/firebase_UserLiveQueue.dart';
import 'package:user_profile_management/page/Theme.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final QueueService _queueService = QueueService();
  final TextEditingController _userNumberController = TextEditingController();

  int? _currentNumber;
  List<int> _queueNumbers = [];
  bool _hasJoinedQueue = false;
  int? _myNumber;

  @override
  void initState() {
    super.initState();
    _listenToQueueUpdates();
  }

  void _listenToQueueUpdates() {
    // Listen to current number updates
    _queueService.listenToCurrentNumber().listen((currentNumber) {
      setState(() {
        _currentNumber = currentNumber;
      });
    });

    // Listen to queue updates
    _queueService.listenToQueue().listen((queueNumbers) {
      setState(() {
        _queueNumbers = queueNumbers;
        // Check if user's number is still in queue
        if (_myNumber != null) {
          _hasJoinedQueue = _queueNumbers.contains(_myNumber);
        }
      });
    });
  }

  void _joinQueue() async {
    if (_userNumberController.text.isNotEmpty) {
      int enteredNumber = int.parse(_userNumberController.text);

      try {
        await _queueService.addToQueue(enteredNumber);
        setState(() {
          _myNumber = enteredNumber;
          _hasJoinedQueue = true;
        });
        _userNumberController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully joined the queue!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join queue: $e')),
        );
      }
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
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_hasJoinedQueue) ...[
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
                onPressed: _joinQueue,
                child: Text('Join Queue'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ],
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Current Number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_currentNumber ?? "Loading..."}',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Queue List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _queueNumbers.length,
                          itemBuilder: (context, index) {
                            final number = _queueNumbers[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: number == _myNumber
                                    ? Colors.teal
                                    : Colors.grey[300],
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                'Token #$number',
                                style: TextStyle(
                                  fontWeight: number == _myNumber
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: number == _myNumber
                                      ? Colors.teal
                                      : Colors.black,
                                ),
                              ),
                              trailing: number == _myNumber
                                  ? Text('Your Number',
                                      style: TextStyle(color: Colors.teal))
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

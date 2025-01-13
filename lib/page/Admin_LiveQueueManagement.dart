import 'package:flutter/material.dart';
import 'package:user_profile_management/back-end/firebase_AdminUpdateQueue.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/Widget_outside_appbar.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final QueueService _queueService = QueueService();
  int? _currentNumber;
  List<int> _queueNumbers = [];

  @override
  void initState() {
    super.initState();
    _listenToQueueUpdates();
  }

  void _listenToQueueUpdates() {
    _queueService.listenToCurrentNumber().listen((currentNumber) {
      setState(() {
        _currentNumber = currentNumber;
      });
    });

    _queueService.listenToQueue().listen((queueNumbers) {
      setState(() {
        _queueNumbers = queueNumbers;
      });
    });
  }

  void _callNextNumber() async {
    if (_queueNumbers.isNotEmpty) {
      int nextNumber = _queueNumbers[0];
      try {
        await _queueService.updateCurrentNumber(nextNumber);
        await _queueService.removeFromQueue(nextNumber);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Called number $nextNumber')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to call next number')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: WidgetOutsideAppbar(title: 'Queue Management', logoAsset: '',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Current Number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_currentNumber ?? "No active number"}',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          _queueNumbers.isNotEmpty ? _callNextNumber : null,
                      child: const Text('Call Next Number',style: TextStyle(color: fivethcolour),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
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
                        'Waiting Queue',
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
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Text('${index + 1}',style: TextStyle(color: fivethcolour),),
                              ),
                              title: Text(
                                'Token #${_queueNumbers[index]}',
                                style: TextStyle(fontSize: 16),
                              ),
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

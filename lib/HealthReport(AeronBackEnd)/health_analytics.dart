import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _height = 180.0;
  double _weight = 60.0;
  int _age = 21;
  double _bmi = 0.0;
  String _result = '';

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  void _calculateBMI() {
    setState(() {
      _height = double.parse(_heightController.text);
      _weight = double.parse(_weightController.text);
      _age = int.parse(_ageController.text);

      _bmi = _weight / (_height / 100 * _height / 100);

      if (_bmi < 18.5) {
        _result = 'Underweight';
      } else if (_bmi >= 18.5 && _bmi < 25.0) {
        _result = 'You are healthy';
      } else {
        _result = 'Overweight';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health Analytics'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weight'),
                          TextField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                          ),
                          Text('$_weight kg'),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Height'),
                          TextField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                          ),
                          Text('$_height cm'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age'),
                          TextField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                          ),
                          Text('$_age yrs'),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BMI'),
                          Text('$_bmi'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: Text('Calculate'),
              ),
              SizedBox(height: 16.0),
              Text('Result: $_result'),
            ],
          ),
        ),
      ),
    );
  }
}

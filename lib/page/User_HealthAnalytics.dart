import 'package:flutter/material.dart';
import 'package:user_profile_management/back-end/firebase_HealthAnalytics.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/page/Widget_outside_appbar.dart';

class HealthAnalytics extends StatefulWidget {
  const HealthAnalytics({super.key});

  @override
  _HealthAnalyticsState createState() => _HealthAnalyticsState();
}

class _HealthAnalyticsState extends State<HealthAnalytics> {
  double _height = 0;
  double _weight = 0;
  int _age = 0;
  double _bmi = 0.0;
  String _result = '';

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  void _calculateBMI() async {
    setState(() {
      _height = double.parse(_heightController.text);
      _weight = double.parse(_weightController.text);
      _age = int.parse(_ageController.text);

      _bmi = _weight / (_height / 100 * _height / 100);

      if (_bmi < 18.5) {
        _result = 'Underweight';
      } else if (_bmi >= 18.5 && _bmi < 25.0) {
        _result = 'Healthy';
      } else {
        _result = 'Overweight';
      }
    });

    // Save BMI data to Firebase
    await _firebaseService.saveBMIData(
      height: _height,
      weight: _weight,
      age: _age,
      bmi: _bmi,
      result: _result,
    );
  }

  void _clearFields() {
    setState(() {
      _heightController.clear();
      _weightController.clear();
      _ageController.clear();
      _height = 0;
      _weight = 0;
      _age = 0;
      _bmi = 0.0;
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: WidgetOutsideAppbar(title: 'Health Analytics', logoAsset: '',),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Body Measurements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Weight (kg)',
                        controller: _weightController,
                        initialValue: _weight.toString(),
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Height (cm)',
                        controller: _heightController,
                        initialValue: _height.toString(),
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Age (years)',
                        controller: _ageController,
                        initialValue: _age.toString(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: firstcolour,
                    ),
                      onPressed: _calculateBMI,
                      child: const Text('Calculate BMI',style: TextStyle(color:fivethcolour),),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fourthcolour,
                    ),
                    child: const Text('Clear', style: TextStyle(color:fivethcolour),),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_bmi > 0) _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller..text = controller.text.isEmpty ? initialValue : controller.text,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    Color resultColor;
    switch (_result) {
      case 'Healthy':
        resultColor = Colors.green;
        break;
      case 'Underweight':
        resultColor = Colors.orange;
        break;
      case 'Overweight':
        resultColor = Colors.red;
        break;
      default:
        resultColor = Colors.grey;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Your Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: firstcolour,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: resultColor, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: resultColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

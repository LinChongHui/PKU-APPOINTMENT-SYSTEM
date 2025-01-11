/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../medicalrecord/medical_record.dart';
import '../medicalrecord/medical_record_service.dart';

class EditMedicalRecord extends StatefulWidget {
  final MedicalRecord? record;

  const EditMedicalRecord({super.key, this.record});

  @override
  _EditMedicalRecordState createState() => _EditMedicalRecordState();
}

class _EditMedicalRecordState extends State<EditMedicalRecord> {
  final _formKey = GlobalKey<FormState>();
  final _recordService = MedicalRecordService();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  List<String> reasons = [''];
  List<Map<String, String>> medicines = [
    {'name': '', 'dosage': ''}
  ];

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      selectedDate = widget.record!.visitDate;
      selectedTime = TimeOfDay(
        hour: int.parse(widget.record!.visitTime.split(':')[0]),
        minute: int.parse(widget.record!.visitTime.split(':')[1]),
      );
      reasons = List.from(widget.record!.reasons);
      medicines = widget.record!.medicines.entries
          .map((e) => {'name': e.key, 'dosage': e.value})
          .toList();
    } else {
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Record' : 'Edit Record'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            const SizedBox(height: 16),
            const Text('Reasons:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...reasons.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: entry.value,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => reasons[entry.key] = value,
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter a reason'
                            : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          reasons.removeAt(entry.key);
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  reasons.add('');
                });
              },
              child: const Text('Add Reason'),
            ),
            const SizedBox(height: 16),
            const Text('Medicines:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...medicines.asMap().entries.map((entry) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: entry.value['name'],
                              decoration: const InputDecoration(
                                labelText: 'Medicine Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) =>
                                  medicines[entry.key]['name'] = value,
                              validator: (value) => value?.isEmpty == true
                                  ? 'Please enter medicine name'
                                  : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              setState(() {
                                medicines.removeAt(entry.key);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: entry.value['dosage'],
                        decoration: const InputDecoration(
                          labelText: 'Dosage/Instructions',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            medicines[entry.key]['dosage'] = value,
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter dosage'
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  medicines.add({'name': '', 'dosage': ''});
                });
              },
              child: const Text('Add Medicine'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveRecord,
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formattedHour = selectedTime.hour.toString().padLeft(2, '0');
      final formattedMinute = selectedTime.minute.toString().padLeft(2, '0');

      final medicinesMap = {
        for (var medicine in medicines.where((m) => m['name']!.isNotEmpty))
          medicine['name']!: medicine['dosage']!
      };

      final record = MedicalRecord(
        id: widget.record?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        visitDate: selectedDate,
        visitTime: '$formattedHour:$formattedMinute',
        reasons: reasons.where((reason) => reason.isNotEmpty).toList(),
        medicines: medicinesMap,
      );

      if (widget.record == null) {
        await _recordService.addRecord(record);
      } else {
        await _recordService.updateRecord(record);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record saved successfully')),
        );
        Navigator.pop(context);
      }
    }
  }
}
*/
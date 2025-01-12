import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:user_profile_management/back-end/firebase_MedicalRecord.dart';

class AddEditRecordForm extends StatefulWidget {
  final MedicalRecord? record;
  const AddEditRecordForm({Key? key, this.record}) : super(key: key);

  @override
  _AddEditRecordFormState createState() => _AddEditRecordFormState();
}

class _AddEditRecordFormState extends State<AddEditRecordForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TextEditingController _timeController;
  late TextEditingController _matricNumberController;
  List<String> _reasons = [];
  List<Medicine> _medicines = [];
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  // Controllers for medicine input
  final _medicineNameController = TextEditingController();
  final _medicineDosageController = TextEditingController();
  final _medicineFrequencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.record?.visitDate ?? DateTime.now();
    _timeController = TextEditingController(text: widget.record?.time ?? '');
    _matricNumberController = TextEditingController(text: widget.record?.matricNumber ?? '');
    _reasons = widget.record?.reasons.toList() ?? [];
    _medicines = widget.record?.medicines.toList() ?? [];
  }

  void _addMedicine() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medicine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _medicineNameController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            TextField(
              controller: _medicineDosageController,
              decoration: const InputDecoration(labelText: 'Dosage'),
            ),
            TextField(
              controller: _medicineFrequencyController,
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _medicines.add(Medicine(
                  name: _medicineNameController.text,
                  dosage: _medicineDosageController.text,
                  frequency: _medicineFrequencyController.text,
                ));
              });
              _medicineNameController.clear();
              _medicineDosageController.clear();
              _medicineFrequencyController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _validateMatricNumber(String matricNumber) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('personalInfo.matricNumber', isEqualTo: matricNumber)
        .get();

    if (userDoc.docs.isEmpty) {
      throw Exception('Student with matric number $matricNumber not found');
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Validate matric number exists
      await _validateMatricNumber(_matricNumberController.text);

      final record = MedicalRecord(
        id: widget.record?.id ?? '',
        matricNumber: _matricNumberController.text,
        visitDate: _selectedDate,
        time: _timeController.text,
        reasons: _reasons,
        medicines: _medicines,
      );

      if (widget.record == null) {
        await FirebaseFirestore.instance
            .collection('medical_records')
            .add(record.toMap());
      } else {
        await FirebaseFirestore.instance
            .collection('medical_records')
            .doc(record.id)
            .update(record.toMap());
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Record' : 'Edit Record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveRecord,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _matricNumberController,
              decoration: const InputDecoration(
                labelText: 'Matric Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter matric number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter time';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Reasons Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reasons',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _reasonController,
                            decoration: const InputDecoration(
                              labelText: 'Add Reason',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (_reasonController.text.isNotEmpty) {
                              setState(() {
                                _reasons.add(_reasonController.text);
                                _reasonController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    ..._reasons.map((reason) => ListTile(
                          title: Text(reason),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() => _reasons.remove(reason));
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Medicines Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Medicines',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addMedicine,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Medicine'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._medicines.map((medicine) => Card(
                          child: ListTile(
                            title: Text(medicine.name),
                            subtitle: Text(
                              'Dosage: ${medicine.dosage}\nFrequency: ${medicine.frequency}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() => _medicines.remove(medicine));
                              },
                            ),
                          ),
                        )),
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

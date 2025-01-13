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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _medicineDosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _medicineFrequencyController,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
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
        await FirebaseFirestore.instance.collection('medical_records').add(record.toMap());
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
  final Color primaryColor = const Color(0xFF00897B);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: Text(
            widget.record == null ? 'Add Medical Record' : 'Edit Medical Record',
            style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
          ),
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Colors.white),
              )
            else
              IconButton(
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                onPressed: _saveRecord,
                tooltip: 'Save Record',
              ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Matric Number Card
                _buildCard(
                  title: 'Student Information',
                  child: TextFormField(
                    controller: _matricNumberController,
                    decoration: _buildInputDecoration(
                      'Matric Number',
                      Icons.badge_rounded,
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter matric number' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Date and Time Card
                _buildCard(
                  title: 'Visit Details',
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: primaryColor),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _timeController,
                        decoration: _buildInputDecoration(
                          'Visit Time',
                          Icons.access_time_rounded,
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Please enter time' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Reasons Card
                _buildCard(
                  title: 'Reasons for Visit',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _reasonController,
                              decoration: _buildInputDecoration(
                                'Add Reason',
                                Icons.description_rounded,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: primaryColor),
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
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _reasons.map((reason) => _buildChip(
                          reason,
                          onDelete: () {
                            setState(() => _reasons.remove(reason));
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Medicines Card
                _buildCard(
                  title: 'Prescribed Medicines',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addMedicine,
                        icon: const Icon(Icons.add,color: Colors.white,),
                        label: const Text('Add Medicine',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._medicines.map((medicine) => Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: const Icon(Icons.medication_rounded, color: Colors.white),
                          ),
                          title: Text(
                            medicine.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Dosage: ${medicine.dosage}\nFrequency: ${medicine.frequency}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: primaryColor),
                            onPressed: () {
                              setState(() => _medicines.remove(medicine));
                            },
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {required VoidCallback onDelete}) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.cancel, size: 18),
      onDeleted: onDelete,
      backgroundColor: primaryColor.withOpacity(0.1),
      deleteIconColor: primaryColor,
      labelStyle: TextStyle(color: primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: primaryColor.withOpacity(0.8)),
    );
  }
}


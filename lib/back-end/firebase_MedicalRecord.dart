// medical_record.dart
class MedicalRecord {
  final String id;
  final String matricNumber;
  final DateTime visitDate;
  final String time;
  final List<String> reasons;
  final List<Medicine> medicines;

  MedicalRecord({
    required this.id,
    required this.matricNumber,
    required this.visitDate,
    required this.time,
    required this.reasons,
    required this.medicines,
  });

  factory MedicalRecord.fromMap(Map<String, dynamic> map, String id) {
    return MedicalRecord(
      id: id,
      matricNumber: map['matricNumber'] ?? '',
      visitDate: DateTime.parse(map['visitDate']),
      time: map['time'] ?? '',
      reasons: List<String>.from(map['reasons'] ?? []),
      medicines: (map['medicines'] as List<dynamic>?)?.map((medicine) => 
        Medicine.fromMap(medicine as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'matricNumber': matricNumber,
      'visitDate': visitDate.toIso8601String(),
      'time': time,
      'reasons': reasons,
      'medicines': medicines.map((medicine) => medicine.toMap()).toList(),
    };
  }
}

class Medicine {
  final String name;
  final String dosage;
  final String frequency;

  Medicine({
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
    };
  }
}
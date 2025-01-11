class MedicalRecord {
  final String id;
  final DateTime visitDate;
  final String visitTime;
  final List<String> reasons;
  final Map<String, String> medicines;

  MedicalRecord({
    required this.id,
    required this.visitDate,
    required this.visitTime,
    required this.reasons,
    required this.medicines,
  });

  // Convert MedicalRecord to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visitDate': visitDate.toIso8601String(),
      'visitTime': visitTime,
      'reasons': reasons,
      'medicines': medicines, // Save as a map
    };
  }

  // Convert Map to MedicalRecord
  static MedicalRecord fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      visitDate: DateTime.parse(map['visitDate']),
      visitTime: map['visitTime'],
      reasons: List<String>.from(map['reasons']),
      medicines: Map<String, String>.from(map['medicines']),
    );
  }
}

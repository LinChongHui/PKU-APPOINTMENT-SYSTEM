// lib/models/health_report.dart
class HealthReport {
  final String id;
  final String matricNumber;  // Changed from uid to matricNumber
  final DateTime date;
  final String consultantName;
  final String reportSummary;

  HealthReport({
    required this.id,
    required this.matricNumber,  // Updated constructor
    required this.date,
    required this.consultantName,
    required this.reportSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'matricNumber': matricNumber,  // Updated field name
      'date': date.toIso8601String(),
      'consultantName': consultantName,
      'reportSummary': reportSummary,
    };
  }

  factory HealthReport.fromMap(String id, Map<String, dynamic> map) {
    return HealthReport(
      id: id,
      matricNumber: map['matricNumber'] ?? '',  // Updated field name
      date: DateTime.parse(map['date']),
      consultantName: map['consultantName'] ?? '',
      reportSummary: map['reportSummary'] ?? '',
    );
  }
}
// lib/models/health_report.dart
class HealthReport {
  final String id;
  final DateTime date;
  final String consultantName;
  final String reportSummary;

  HealthReport({
    required this.id,
    required this.date,
    required this.consultantName,
    required this.reportSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'consultantName': consultantName,
      'reportSummary': reportSummary,
    };
  }

  factory HealthReport.fromMap(String id, Map<String, dynamic> map) {
    return HealthReport(
      id: id,
      date: DateTime.parse(map['date']),
      consultantName: map['consultantName'] ?? '',
      reportSummary: map['reportSummary'] ?? '',
    );
  }
}

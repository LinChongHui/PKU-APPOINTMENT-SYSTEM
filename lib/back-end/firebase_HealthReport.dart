import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure this import is at the top
import 'package:intl/intl.dart';

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
      'date': date.toIso8601String(), // Store date in ISO format
      'consultantName': consultantName,
      'reportSummary': reportSummary,
    };
  }

  factory HealthReport.fromMap(String id, Map<String, dynamic> map) {
    DateTime parsedDate;
    final dateValue = map['date'];

    try {
      if (dateValue is Timestamp) {
        // Handle Firestore Timestamp
        parsedDate = dateValue.toDate();
      } else if (dateValue is String) {
        // Try parsing different date formats
        try {
          // First try ISO format
          parsedDate = DateTime.parse(dateValue);
        } catch (e) {
          // Then try the format from your form (yyyy-MM-dd)
          try {
            parsedDate = DateFormat('yyyy-MM-dd').parse(dateValue);
          } catch (e) {
            // Finally try the display format (MMM d, yyyy)
            parsedDate = DateFormat('MMM d, yyyy').parse(dateValue);
          }
        }
      } else {
        // Default to current date if no valid date is found
        parsedDate = DateTime.now();
        print('Warning: Invalid date format in database, using current date');
      }
    } catch (e) {
      print('Error parsing date: $dateValue. Error: $e');
      // Provide a fallback date instead of throwing an exception
      parsedDate = DateTime.now();
    }

    // Fix for checking both possible field names for summary
    return HealthReport(
      id: id,
      date: parsedDate,
      consultantName: map['consultantName'] ?? '',
      reportSummary: map['reportSummary'] ?? map['summary'] ?? '', // Correctly check both fields
    );
  }

  // Add a method to format date for display
  String getFormattedDate() {
    return DateFormat('MMMM dd, yyyy').format(date);
  }
  
  // Add a method to get relative time
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return getFormattedDate();
    }
  }
}

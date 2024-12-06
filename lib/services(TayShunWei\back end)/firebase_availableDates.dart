import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get time slots for a specific date
  Future<List<String>> getTimeSlots(DateTime date) async {
    try {
      // Check if date is before today
      DateTime today = DateTime.now();
      if (date.isBefore(DateTime(today.year, today.month, today.day))) {
        throw Exception('Selected date is before today');
      }

      // Get day of the week
      String dayOfWeek = DateFormat('EEEE').format(date); // e.g., 'Sunday'

      // Get time slots for the day of the week from the database
      DocumentSnapshot timeSlotDoc =
          await _firestore.collection('timeSlots').doc(dayOfWeek).get();

      if (!timeSlotDoc.exists) {
        throw Exception('No time slots found for $dayOfWeek');
      }

      List<dynamic> timeSlots = timeSlotDoc['slot'];

      return timeSlots.cast<String>();
    } catch (e) {
      print('Error fetching time slots: $e');
      throw Exception('Failed to fetch time slots');
    }
  }
}

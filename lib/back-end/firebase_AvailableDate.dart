import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get time slots for a specific date
  Future<List<String>> getTimeSlots(DateTime date) async {
    try {
      // Get current time
      DateTime now = DateTime.now();
      String currentTime =
          DateFormat('HH:mm').format(now); // Current time in 24-hour format

      // Check if date is before today
      DateTime today = DateTime(now.year, now.month, now.day);
      if (date.isBefore(today)) {
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

      // Filter out time slots that have already passed for today
      List<String> filteredTimeSlots = timeSlots.cast<String>().where((slot) {
        if (date.isAtSameMomentAs(today)) {
          // Compare only for today's date
          return DateFormat('HH:mm')
              .parse(slot)
              .isAfter(DateFormat('HH:mm').parse(currentTime));
        }
        return true; // Allow all slots for future dates
      }).toList();

      return filteredTimeSlots;
    } catch (e) {
      print('Error fetching time slots: $e');
      throw Exception('Failed to fetch time slots');
    }
  }
}

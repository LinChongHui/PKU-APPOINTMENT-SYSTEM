import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get time slots for a specific date
  Future<List<String>> getTimeSlots(DateTime selectedDate) async {
    try {
      // Get current date and time
      DateTime now = DateTime.now();

      // Create DateTime objects for comparison
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime selectedStart =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

      // Check if selected date is before today
      if (selectedStart.isBefore(todayStart)) {
        throw Exception('Selected date is before today');
      }

      // Get day of the week
      String dayOfWeek = DateFormat('EEEE').format(selectedDate);

      // Get time slots for the day of the week from the database
      DocumentSnapshot timeSlotDoc =
          await _firestore.collection('timeSlots').doc(dayOfWeek).get();

      if (!timeSlotDoc.exists) {
        throw Exception('No time slots found for $dayOfWeek');
      }

      List<dynamic> timeSlots = timeSlotDoc['slot'];

      // Filter out time slots that have already passed
      List<String> filteredTimeSlots = timeSlots.cast<String>().where((slot) {
        // Remove quotes and parse the time
        String cleanSlot = slot.replaceAll('"', '');
        List<String> timeParts = cleanSlot.split(':');
        int slotHour = int.parse(timeParts[0]);
        int slotMinute = int.parse(timeParts[1]);

        // If selected date is today, filter based on current time
        if (selectedStart.isAtSameMomentAs(todayStart)) {
          // Add a buffer of 30 minutes to current time
          DateTime currentTimeWithBuffer = now.add(const Duration(minutes: 30));

          // Create a DateTime object for the slot time today
          DateTime slotDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            slotHour,
            slotMinute,
          );

          return slotDateTime.isAfter(currentTimeWithBuffer);
        }

        // For future dates, show all slots
        return true;
      }).toList();

      // Sort the filtered time slots
      filteredTimeSlots.sort((a, b) {
        String cleanA = a.replaceAll('"', '');
        String cleanB = b.replaceAll('"', '');
        return DateFormat('HH:mm')
            .parse(cleanA)
            .compareTo(DateFormat('HH:mm').parse(cleanB));
      });

      return filteredTimeSlots;
    } catch (e) {
      print('Error fetching time slots: $e');
      throw Exception('Failed to fetch time slots');
    }
  }
}

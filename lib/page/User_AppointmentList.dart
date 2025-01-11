import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/back-end/firebase_AppointmentList.dart';

import 'Widget_inside_appbar_backarrow.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({Key? key}) : super(key: key);

  @override
  _AppointmentHistoryScreenState createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  FirebaseService firebaseService = FirebaseService();
  List<Map<String, dynamic>> appointmentHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAppointmentHistory();
  }

  // Load appointment history from Firebase
  void loadAppointmentHistory() async {
    List<Map<String, dynamic>> history =
        await firebaseService.fetchAppointmentHistory();
    print("Fetched appointment history: $history"); // Debug log
    setState(() {
      appointmentHistory = history;
      isLoading = false;
    });
  }

  // Delete an appointment if the date is not in the past
  void deleteAppointment(String id, String date) async {
    DateTime appointmentDate = DateFormat('yyyy-MM-dd').parse(date);
    if (appointmentDate.isAfter(DateTime.now())) {
      await firebaseService.deleteAppointment(id); // Delete from Firebase
      setState(() {
        appointmentHistory.removeWhere(
            (appointment) => appointment['id'] == id); // Remove from the UI
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete past appointments.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: '     Appointment List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointmentHistory.isEmpty
              ? const Center(
                  child: Text(
                  'No appointment history found.',
                  style: TextStyle(fontSize: 18),
                ))
              : ListView.builder(
                  itemCount: appointmentHistory.length,
                  itemBuilder: (context, index) {
                    final appointment = appointmentHistory[index];
                    DateTime appointmentDate =
                        DateFormat('yyyy-MM-dd').parse(appointment['date']);
                    bool isFutureAppointment =
                        appointmentDate.isAfter(DateTime.now());
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(appointment['service'][0].toUpperCase()),
                        ),
                        title: Text(appointment['service']),
                        subtitle: Text(
                            '${appointment['date']} at ${appointment['time']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentDetailsScreen(
                                            appointment: appointment),
                                  ),
                                );
                              },
                              child: const Text('Details'),
                            ),
                            if (isFutureAppointment)
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: fourthcolour),
                                onPressed: () => deleteAppointment(
                                    appointment['id'], appointment['date']),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailsScreen({required this.appointment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: '     Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${appointment['service']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Date: ${appointment['date']}'),
            Text('Time: ${appointment['time']}'),
            const SizedBox(height: 8),
            Text('Comments: ${appointment['comment']}'),
          ],
        ),
      ),
    );
  }
}
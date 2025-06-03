// lib/view/appointments/appointments_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carecaps2/common/color_extention.dart';
import 'package:carecaps2/services/firestore_service.dart' as fs_service;


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});
  @override
  _AppointmentsViewState createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  bool remindersEnabled = true;
  bool showUpcoming = true;
  final _dateFmt = DateFormat('MMM d, yyyy');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Convert to local timezone
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appointment_channel',
          'Appointment Reminders',
          channelDescription: 'Notifications for upcoming appointments',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // We want it to fire at the EXACT time of appointment
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('📅 Scheduled notification: "$title" at $scheduledTime');
    Fluttertoast.showToast(
      msg:
          "Reminder set for ${DateFormat('MMM d, yyyy – HH:mm').format(scheduledTime)}",
    );
  }

  Future<void> cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print('❌ Cancelled notification with id: $id');
  }

  Future<void> _toggleReminders(
      bool enabled, List<fs_service.Appointment> allApps) async {
    setState(() => remindersEnabled = enabled);

    if (enabled) {
      final now = DateTime.now();
      for (var appt in allApps) {
        // Only schedule if appointment is still in the future
        if (appt.date.isAfter(now)) {
          // If you prefer 15 minutes before, replace the next line with:
          // final scheduledTime = appt.date.subtract(const Duration(minutes: 15));
          final scheduledTime = appt.date;

          // Make sure scheduledTime is still in the future
          if (scheduledTime.isAfter(now)) {
            await showReminderNotification(
              id: appt.appid.hashCode,
              title: 'Appointment Reminder',
              body:
                  'Upcoming: ${appt.doctor} on ${_dateFmt.format(appt.date)} at ${appt.timeString}',
              scheduledTime: scheduledTime,
            );
          } else {
            print(
                '⚠️ Skipped scheduling for ${appt.doctor} (time $scheduledTime is past)');
          }
        }
      }
    } else {
      // Cancel all notifications for every appointment
      for (var appt in allApps) {
        await cancelReminder(appt.appid.hashCode);
      }
      Fluttertoast.showToast(msg: "All appointment reminders cancelled.");
    }
  }

  Widget _buildTab(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Tcolor.primary2 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF0F3C42),
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String txt) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF23414E)),
        const SizedBox(width: 6),
        Text(
          txt,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(168, 10, 45, 50),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'Poppins'),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Appointments",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF23414E),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),

                // Toggle “Upcoming” / “Past”
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(35, 88, 154, 178),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildTab(
                          "Upcoming", showUpcoming, () => setState(() => showUpcoming = true)),
                      _buildTab(
                          "Past", !showUpcoming, () => setState(() => showUpcoming = false)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // StreamBuilder that drives both the ListView and the Reminders box
                Expanded(
                  child: StreamBuilder<List<fs_service.Appointment>>(
                    stream: fs_service.FirestoreService().streamAppointments(),
                    builder: (ctx, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snap.hasError) {
                        return Center(child: Text("Error: ${snap.error}"));
                      }

                      final allApps = snap.data ?? [];
                      final now = DateTime.now();
                      final filtered = allApps
                          .where((a) =>
                              showUpcoming ? a.date.isAfter(now) : a.date.isBefore(now))
                          .toList();

                      // If no appointments match, show an empty message + Reminders box
                      if (filtered.isEmpty) {
                        return Column(
                          children: [
                            const Expanded(
                              child: Center(child: Text("No appointments found.")),
                            ),
                            const Divider(),
                            const SizedBox(height: 8),
                            _RemindersBox(
                              enabled: remindersEnabled,
                              onToggle: (v) =>
                                  _toggleReminders(v, allApps.cast<fs_service.Appointment>()),
                              nextAppointment: null,
                            ),
                          ],
                        );
                      }

                      // Otherwise, sort ascending by date, then pick the first as next
                      filtered.sort((a, b) => a.date.compareTo(b.date));
                      final nextApp = filtered.first;

                      return Column(
                        children: [
                          // 1) List of appointment cards
                          Expanded(
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final a = filtered[i];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Tcolor.primary2.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Tcolor.primary,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(Icons.person,
                                                color: Colors.white, size: 20),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                a.doctor ?? '',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Color(0xFF23414E),
                                                ),
                                              ),
                                              Text(
                                                a.specialty ?? '',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      _infoRow(Icons.calendar_month_outlined,
                                          _dateFmt.format(a.date)),
                                      const SizedBox(height: 6),
                                      _infoRow(Icons.access_time, a.timeString),
                                      const SizedBox(height: 6),
                                      _infoRow(Icons.location_on_outlined, a.location),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // 2) Divider + Reminders box
                          const Divider(),
                          const SizedBox(height: 8),
                          _RemindersBox(
                            enabled: remindersEnabled,
                            onToggle: (v) =>
                                _toggleReminders(v, allApps.cast<fs_service.Appointment>()),
                            nextAppointment: nextApp,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the “Reminders” switch and, if enabled & nextAppointment ≠ null,
/// displays “Next in: Xd Xh Xm …”
class _RemindersBox extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final fs_service.Appointment? nextAppointment;

  const _RemindersBox({
    required this.enabled,
    required this.onToggle,
    required this.nextAppointment,
  });

  String _computeTimeLeftString(DateTime appointmentTime) {
    final now = DateTime.now();
    final diff = appointmentTime.difference(now);
    if (diff.isNegative) return "Now";

    if (diff.inDays > 0) {
      return "${diff.inDays}d ${diff.inHours % 24}h";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h ${diff.inMinutes % 60}m";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m ${diff.inSeconds % 60}s";
    } else {
      return "${diff.inSeconds}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeLeftText = nextAppointment != null && enabled
        ? _computeTimeLeftString(nextAppointment!.date)
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: enabled ? Tcolor.secondary6 : Tcolor.secondary3,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Left side: “Reminders” label (+ “Next in: …” if available)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reminders",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: enabled ? Tcolor.secondary5 : Tcolor.secondary4,
                  ),
                ),
                if (timeLeftText != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Next in: $timeLeftText",
                    style: TextStyle(
                      fontSize: 12,
                      color: enabled
                          ? const Color(0xFF0A2D32)
                          : const Color(0xFF53656A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Right side: the Switch
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: const Color(0xFF6A8B6C),
            activeTrackColor: const Color(0xFFDFF5E0),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

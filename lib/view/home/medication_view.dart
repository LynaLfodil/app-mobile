// lib/view/medication/medication_view.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carecaps2/common/color_extention.dart';
import 'package:carecaps2/services/firestore_service.dart';
import 'package:carecaps2/view/lib/models/medication.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MedicationView extends StatefulWidget {
  const MedicationView({super.key});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  bool remindersEnabled = true;
  bool showCurrent = true;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _setupTimeZoneAndNotifications();
  }

  Future<void> _setupTimeZoneAndNotifications() async {
    try {
      tz.initializeTimeZones();
      await initializeNotifications();
    } catch (e) {
      print('Error initializing time zones or notifications: $e');
    }
  }

  Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
}

// ✅ Step 3: Request permission for exact alarms
Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    try {
      const intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } catch (e) {
      print('⚠️ Failed to open exact alarm settings: $e');

      final packageInfo = await PackageInfo.fromPlatform();
      final fallbackIntent = AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        arguments: <String, dynamic>{
          'android.provider.extra.APP_PACKAGE': packageInfo.packageName,
        },
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await fallbackIntent.launch();
    }
  }
}

// ✅ Step 4: Schedule notification
Future<void> showReminderNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledTime,
}) async {
  final tz.TZDateTime tzScheduledTime =
      tz.TZDateTime.from(scheduledTime, tz.local);

  print('▶ Scheduling notification ID=$id at $tzScheduledTime (local)');

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Medication Reminders',
          channelDescription: 'Notifications for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    Fluttertoast.showToast(
      msg:
          "Reminder set for ${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}",
    );
      } on PlatformException catch (e) {
    print('⚠️ Could not schedule exact alarm: $e');

    Fluttertoast.showToast(
      msg:
          "Exact alarms are not permitted. Tap to enable in system settings.",
    );

    await requestExactAlarmPermission();
  }
}

  Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    Fluttertoast.showToast(msg: "All medication reminders cancelled.");
    print('❌ All medication reminders cancelled');
  }

  Future<void> _toggleReminders(bool enabled, List<Medication> allMeds) async {
    setState(() => remindersEnabled = enabled);

    if (!enabled) {
      // Cancel all if switched off
      await cancelAllReminders();
      return;
    }

    // 1) Filter to “current” medications only
    final now = DateTime.now();
    final currentMeds = allMeds.where((m) => m.to.isAfter(now)).toList();

    if (currentMeds.isEmpty) {
      Fluttertoast.showToast(msg: "No current medications to schedule.");
      return;
    }

    // 2) Compute next‐up dose time among them
    final List<DateTime> nextDoseTimes = [];
    for (var med in currentMeds) {
      try {
        final parts = med.time.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        DateTime candidate = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );
        if (candidate.isBefore(now)) {
          candidate = candidate.add(const Duration(days: 1));
        }
        nextDoseTimes.add(candidate);
      } catch (_) {
        print(
            '⚠️ Skipping "${med.name}" because med.time="${med.time}" is invalid.');
      }
    }

    if (nextDoseTimes.isEmpty) {
      Fluttertoast.showToast(
          msg: "No valid times found for current medications.");
      return;
    }

    nextDoseTimes.sort();
    final nextMedTime = nextDoseTimes.first;
    print('▶ Earliest next dose at $nextMedTime');

    // 3) Schedule a single “you have meds to take now” notification
    await showReminderNotification(
      id: 0,
      title: 'Medication Reminder',
      body: 'You have medications to take now.',
      scheduledTime: nextMedTime,
    );
  }

  String _formatTimeLeft(Duration diff) {
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Medication",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF23414E),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 20),

              // Current / Past toggle
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(35, 88, 154, 178),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showCurrent = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: showCurrent
                                ? Tcolor.primary2
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Current",
                            style: TextStyle(
                              color: showCurrent ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showCurrent = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !showCurrent
                                ? Tcolor.primary2
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Past",
                            style: TextStyle(
                              color: !showCurrent
                                  ? Colors.white
                                  : const Color.fromARGB(221, 8, 58, 60),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Medications List + Reminders box
              Expanded(
                child: StreamBuilder<List<Medication>>(
                  stream: FirestoreService().streamMedications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final allMeds = snapshot.data ?? [];
                    final now = DateTime.now();

                    // Filter current vs past
                    final filtered = allMeds
                        .where((m) =>
                            showCurrent ? m.to.isAfter(now) : m.to.isBefore(now))
                        .toList();

                    // If no meds to display, show “No medications” + Reminders box
                    if (filtered.isEmpty) {
                      return Column(
                        children: [
                          const Expanded(
                            child:
                                Center(child: Text("No medications found.")),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          _MedicationRemindersBox(
                            enabled: remindersEnabled,
                            onToggle: (v) => _toggleReminders(v, allMeds),
                            nextMedicationTime: null,
                          ),
                        ],
                      );
                    }

                    // Compute earliest next‐up dose from filtered meds
                    final List<DateTime> nextDoseTimes = [];
                    for (var med in filtered) {
                      try {
                        final parts = med.time.split(':');
                        final hour = int.parse(parts[0]);
                        final minute = int.parse(parts[1]);

                        DateTime candidate = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          hour,
                          minute,
                        );
                        if (candidate.isBefore(now)) {
                          candidate = candidate.add(const Duration(days: 1));
                        }
                        nextDoseTimes.add(candidate);
                      } catch (_) {
                        // skip invalid time strings
                      }
                    }

                    nextDoseTimes.sort();
                    final nextMedTime = nextDoseTimes.isNotEmpty
                        ? nextDoseTimes.first
                        : null;
                    final diff = nextMedTime?.difference(now);

                    return Column(
                      children: [
                        // List of medication cards
                        Expanded(
                          child: ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final med = filtered[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Tcolor.primary2.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        color: Color(0xFF23414E),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text(
                                          "From: ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        Text(
                                          "${med.from.toLocal()}".split(' ')[0],
                                          style: const TextStyle(
                                              color: Color(0xFF23414E),
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 16),
                                        const Text(
                                          "To: ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        Text(
                                          "${med.to.toLocal()}".split(' ')[0],
                                          style: const TextStyle(
                                              color: Color(0xFF23414E),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Time: ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(left: 0),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Tcolor.secondary6,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                med.time,
                                                style: TextStyle(
                                                    color: Tcolor.secondary5,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: med.taken
                                                    ? Tcolor.secondary6
                                                    : Tcolor.secondary3,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                med.taken ? "taken" : "missed",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: med.taken
                                                      ? Tcolor.secondary5
                                                      : const Color.fromARGB(
                                                          255, 113, 66, 63),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Divider + Reminders box
                        const Divider(),
                        const SizedBox(height: 8),
                        _MedicationRemindersBox(
                          enabled: remindersEnabled,
                          onToggle: (v) => _toggleReminders(v, allMeds),
                          nextMedicationTime: nextMedTime,
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
    );
  }
}

/// The “Reminders” container widget showing the switch and “Next in: …”
class _MedicationRemindersBox extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final DateTime? nextMedicationTime;

  const _MedicationRemindersBox({
    required this.enabled,
    required this.onToggle,
    required this.nextMedicationTime,
  });

  String _formatTimeLeft(Duration diff) {
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
    String? timeLeftText;
    if (nextMedicationTime != null && enabled) {
      final now = DateTime.now();
      final diff = nextMedicationTime!.difference(now);
      timeLeftText = _formatTimeLeft(diff);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: enabled ? Tcolor.secondary6 : Tcolor.secondary3,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Label + optional “Next in” line
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reminders",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
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
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ],
            ),
          ),

          // The switch
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: const Color.fromARGB(255, 106, 139, 108),
            activeTrackColor: const Color.fromARGB(255, 223, 245, 224),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

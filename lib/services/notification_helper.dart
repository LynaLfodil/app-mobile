import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
// to access the plugin

// If flutterLocalNotificationsPlugin is not already defined in main.dart as a global variable, define it here:

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime dateTime,
}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(dateTime, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily if needed
  );
}

Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static void showScheduleNotification(
          {int id = 0,
          required String title,
          required String body,
          String? payload,
          required DateTime scheduleDate}) async =>
      _notification.zonedSchedule(id, title, body,
          tz.TZDateTime.from(scheduleDate, tz.local), NotificationDetails(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);

  static Future init() async {
    final android =  AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android,iOS: ios);
    await _notification.initialize(settings,);
    tz.initializeTimeZones();
  }
}

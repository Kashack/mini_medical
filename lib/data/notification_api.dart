import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static void showScheduleNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    required DateTime scheduleDate,
  }) async {
    _notification.zonedSchedule(id, title, body, tz.TZDateTime.from(scheduleDate, tz.local),
      _notificationDetail(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
  static void showNotification({
    int id = 0,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    _notification.show(id, title, body, _notificationDetail());
  }

  static NotificationDetails _notificationDetail() {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',priority: Priority.high,
            importance: Importance.max));
  }

  static Future init() async {
    // _notification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
    //     .requestPermission();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _notification.initialize(settings);
    tz.initializeTimeZones();
  }
}

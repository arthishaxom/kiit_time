import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  final notiPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    await notiPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await notiPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    tz.initializeTimeZones();
    final String currentTimeZones = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZones));

    const initSettingsAndroid =
        AndroidInitializationSettings("@drawable/ic_launcher");
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    await notiPlugin.initialize(initSettings);
  }

  NotificationDetails notiDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "class_channel_id",
        "Class Notifications",
        channelDescription: "Class Noti Channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> showNoti({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notiPlugin.show(
      id,
      title,
      body,
      notiDetails(),
    );
  }

  Future<void> scheduleNoti({
    int id = 1,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    await notiPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notiDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelAllNoti() async {
    await notiPlugin.cancelAll();
  }
}

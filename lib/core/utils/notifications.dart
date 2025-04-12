import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'dart:io';
import 'dart:typed_data';
import 'env.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
    await _requestPermissions();
    await _requestExactAlarmPermission();
  }

  Future<void> _requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        bool? granted = await androidPlugin.requestExactAlarmsPermission();
        if (granted == false) {
          print("❌ Exact Alarm permission denied.");
        } else {
          print("✅ Exact Alarm permission granted.");
        }
      }
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final bool? granted =
            await androidPlugin.requestNotificationsPermission();
        if (granted == null || !granted) {
          print("❌ Notification permission denied on Android");
        } else {
          print("✅ Notification permission granted on Android");
        }
      }
    }
  }

  Future<void> showInstantNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Test Notification",
      "This is an instant test notification",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel_id',
          'Prayer Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    bool isReminder = false,
  }) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 4000;
    vibrationPattern[2] = 4000;
    vibrationPattern[3] = 4000;

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'prayer_channel_id',
      'Prayer Notifications',
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      vibrationPattern: vibrationPattern,
      visibility: NotificationVisibility.public,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
    );

    final TZDateTime tzTime = TZDateTime.from(scheduledTime, local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "",
    );

    print("✅ Scheduled notification: $title at $tzTime");
  }

  /// **Cancel a specific notification**
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print("❌ Notification with ID $id cancelled");
  }

  /// **Cancel all notifications**
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("❌ All notifications cancelled");
  }
}

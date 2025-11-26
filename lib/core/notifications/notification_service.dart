import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap if needed
  }

  Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  Future<void> scheduleDailyNotification() async {
    if (!_initialized) await initialize();

    await _notifications.zonedSchedule(
      0,
      'HealthMate Reminder',
      'Don\'t forget to log your health today!',
      _nextInstanceOfTime(9, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Health Reminder',
          channelDescription: 'Reminds you to log your daily health metrics',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWaterReminder() async {
    if (!_initialized) await initialize();

    // Schedule every 3 hours starting from now
    final now = tz.TZDateTime.now(tz.local);
    for (int i = 0; i < 8; i++) { // 8 reminders per day (24 hours / 3)
      final scheduledTime = now.add(Duration(hours: i * 3));
      if (scheduledTime.isAfter(now)) {
        await _notifications.zonedSchedule(
          100 + i,
          'Water Reminder',
          'Time to drink water! Stay hydrated 💧',
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'water_reminder',
              'Water Reminder',
              channelDescription: 'Reminds you to drink water every 3 hours',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    // Schedule additional recurring reminders every 3 hours
    for (int i = 1; i <= 7; i++) {
      final scheduledTime = now.add(Duration(hours: i * 3));
      await _notifications.zonedSchedule(
        200 + i,
        'Water Reminder',
        'Time to drink water! Stay hydrated 💧',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'water_reminder',
            'Water Reminder',
            channelDescription: 'Reminds you to drink water every 3 hours',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelDailyNotification() async {
    await _notifications.cancel(0);
  }

  Future<void> cancelWaterReminders() async {
    for (int i = 0; i < 8; i++) {
      await _notifications.cancel(100 + i);
    }
    for (int i = 1; i <= 7; i++) {
      await _notifications.cancel(200 + i);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}


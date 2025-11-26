import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final NotificationService _notificationService = NotificationService();
  static const String _dailyNotificationsKey = 'daily_notifications_enabled';
  static const String _waterReminderKey = 'water_reminder_enabled';

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();
    await _loadAndScheduleNotifications();
  }

  Future<void> _loadAndScheduleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    
    final dailyEnabled = prefs.getBool(_dailyNotificationsKey) ?? false;
    final waterEnabled = prefs.getBool(_waterReminderKey) ?? false;

    if (dailyEnabled) {
      await _notificationService.scheduleDailyNotification();
    }

    if (waterEnabled) {
      await _notificationService.scheduleWaterReminder();
    }
  }

  Future<bool> isDailyNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dailyNotificationsKey) ?? false;
  }

  Future<bool> isWaterReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_waterReminderKey) ?? false;
  }

  Future<void> setDailyNotification(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyNotificationsKey, enabled);

    if (enabled) {
      await _notificationService.scheduleDailyNotification();
    } else {
      await _notificationService.cancelDailyNotification();
    }
  }

  Future<void> setWaterReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_waterReminderKey, enabled);

    if (enabled) {
      await _notificationService.scheduleWaterReminder();
    } else {
      await _notificationService.cancelWaterReminders();
    }
  }
}


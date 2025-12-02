import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate_app/core/notifications/notification_manager.dart';
import 'package:health_mate_app/core/providers/theme_provider.dart';
import 'package:health_mate_app/core/services/user_preferences_service.dart';
import 'package:health_mate_app/core/widgets/welcome_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final NotificationManager _notificationManager = NotificationManager();
  bool _dailyNotificationsEnabled = false;
  bool _waterReminderEnabled = false;
  bool _isLoading = true;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final dailyEnabled = await _notificationManager.isDailyNotificationEnabled();
    final waterEnabled = await _notificationManager.isWaterReminderEnabled();
    final userName = await UserPreferencesService.getUserName();

    setState(() {
      _dailyNotificationsEnabled = dailyEnabled;
      _waterReminderEnabled = waterEnabled;
      _userName = userName;
      _isLoading = false;
    });
  }

  Future<void> _toggleDailyNotifications(bool value) async {
    setState(() {
      _dailyNotificationsEnabled = value;
    });
    await _notificationManager.setDailyNotification(value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'Daily notifications enabled'
                : 'Daily notifications disabled',
          ),
        ),
      );
    }
  }

  Future<void> _toggleWaterReminder(bool value) async {
    setState(() {
      _waterReminderEnabled = value;
    });
    await _notificationManager.setWaterReminder(value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'Water reminders enabled (every 3 hours)'
                : 'Water reminders disabled',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Your Name'),
                  subtitle: Text(_userName ?? 'Not set'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => WelcomeDialog(initialName: _userName),
                      );
                      if (result == true && mounted) {
                        await _loadSettings();
                      }
                    },
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final themeMode = ref.watch(themeProvider);
                    return ListTile(
                      leading: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : themeMode == ThemeMode.light
                                ? Icons.light_mode
                                : Icons.brightness_auto,
                      ),
                      title: const Text('Theme Mode'),
                      subtitle: Text(
                        themeMode == ThemeMode.dark
                            ? 'Dark'
                            : themeMode == ThemeMode.light
                                ? 'Light'
                                : 'System',
                      ),
                      trailing: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode, size: 18),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode, size: 18),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text('Auto'),
                            icon: Icon(Icons.brightness_auto, size: 18),
                          ),
                        ],
                        selected: {themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          ref.read(themeProvider.notifier).setThemeMode(newSelection.first);
                        },
                      ),
                    );
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Daily Notifications'),
                  subtitle: const Text(
                    'Get reminded at 9:00 AM to log your health',
                  ),
                  value: _dailyNotificationsEnabled,
                  onChanged: _toggleDailyNotifications,
                  secondary: const Icon(Icons.notifications),
                ),
                SwitchListTile(
                  title: const Text('Water Reminder'),
                  subtitle: const Text(
                    'Get reminded to drink water every 3 hours',
                  ),
                  value: _waterReminderEnabled,
                  onChanged: _toggleWaterReminder,
                  secondary: const Icon(Icons.water_drop),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('HealthMate'),
                  subtitle: const Text('Personal Health Tracker'),
                ),
              ],
            ),
    );
  }
}


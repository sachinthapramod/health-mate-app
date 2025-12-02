import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate_app/core/theme/app_theme.dart';
import 'package:health_mate_app/core/notifications/notification_manager.dart';
import 'package:health_mate_app/core/providers/theme_provider.dart';
import 'package:health_mate_app/core/services/user_preferences_service.dart';
import 'package:health_mate_app/core/widgets/welcome_dialog.dart';
import 'package:health_mate_app/features/health_records/presentation/screens/dashboard_screen.dart';
import 'package:health_mate_app/features/health_records/presentation/screens/add_record_screen.dart';
import 'package:health_mate_app/features/health_records/presentation/screens/records_list_screen.dart';
import 'package:health_mate_app/features/weekly_summary/presentation/screens/weekly_summary_screen.dart';
import 'package:health_mate_app/features/bmi/presentation/screens/bmi_screen.dart';
import 'package:health_mate_app/features/settings/presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications
  await NotificationManager().initialize();
  
  runApp(
    const ProviderScope(
      child: HealthMateApp(),
    ),
  );
}

class HealthMateApp extends ConsumerWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'HealthMate',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirstLaunch = await UserPreferencesService.isFirstLaunch();
    if (isFirstLaunch && mounted) {
      // Show welcome dialog after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const WelcomeDialog(),
        );
      });
    }
  }

  static final List<Widget> _screens = [
    const DashboardScreen(),
    const RecordsListScreen(),
    const WeeklySummaryScreen(),
    const BMIScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure index is always valid
    final safeIndex = _selectedIndex.clamp(0, _screens.length - 1);
    
    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Weekly',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight_outlined),
            selectedIcon: Icon(Icons.monitor_weight),
            label: 'BMI',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex != 4 // Hide FAB on Settings screen
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddRecordScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Record'),
            )
          : null,
    );
  }
}


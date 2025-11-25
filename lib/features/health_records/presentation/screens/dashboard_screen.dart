import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate_app/core/widgets/health_metric_card.dart';
import 'package:health_mate_app/core/theme/app_theme.dart';
import 'package:health_mate_app/core/utils/date_formatter.dart';
import '../../presentation/providers/health_record_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayRecordAsync = ref.watch(todayRecordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthMate Dashboard'),
        centerTitle: true,
      ),
      body: todayRecordAsync.when(
        data: (record) {
          if (record == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.health_and_safety_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No record for today',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first health entry!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Summary',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormatter.formatDateDisplay(DateTime.now()),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 24),
                HealthMetricCard(
                  title: 'Steps',
                  value: record.steps,
                  unit: 'steps',
                  icon: Icons.directions_walk,
                  color: AppTheme.stepsColor,
                ),
                const SizedBox(height: 16),
                HealthMetricCard(
                  title: 'Calories',
                  value: record.calories,
                  unit: 'kcal',
                  icon: Icons.local_fire_department,
                  color: AppTheme.caloriesColor,
                ),
                const SizedBox(height: 16),
                HealthMetricCard(
                  title: 'Water Intake',
                  value: record.water,
                  unit: 'ml',
                  icon: Icons.water_drop,
                  color: AppTheme.waterColor,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


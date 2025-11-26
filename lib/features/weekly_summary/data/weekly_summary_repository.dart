import '../../health_records/data/db/database_helper.dart';
import '../../health_records/data/models/health_record.dart';

class WeeklySummaryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<HealthRecord>> getLast7DaysRecords() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 6));
      final startDateString = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      ).toIso8601String();
      final endDateString = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      ).toIso8601String();

      final maps = await _dbHelper.getRecordsForDateRange(
        startDateString,
        endDateString,
      );

      // Group by date and aggregate
      final Map<String, HealthRecord> aggregated = {};

      for (var map in maps) {
        final record = HealthRecord.fromMap(map);
        final dateKey = record.date.substring(0, 10); // Get date part only

        if (aggregated.containsKey(dateKey)) {
          final existing = aggregated[dateKey]!;
          aggregated[dateKey] = HealthRecord(
            id: existing.id,
            date: existing.date,
            steps: existing.steps + record.steps,
            calories: existing.calories + record.calories,
            water: existing.water + record.water,
          );
        } else {
          aggregated[dateKey] = record;
        }
      }

      // Fill in missing days with zero values
      final List<HealthRecord> result = [];
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = DateTime(date.year, date.month, date.day).toIso8601String().substring(0, 10);

        if (aggregated.containsKey(dateKey)) {
          result.add(aggregated[dateKey]!);
        } else {
          result.add(HealthRecord(
            date: DateTime(date.year, date.month, date.day).toIso8601String(),
            steps: 0,
            calories: 0,
            water: 0,
          ));
        }
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get weekly summary: $e');
    }
  }
}


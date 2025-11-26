import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/weekly_summary_repository.dart';
import '../../health_records/data/models/health_record.dart';

final weeklySummaryRepositoryProvider =
    Provider<WeeklySummaryRepository>((ref) {
  return WeeklySummaryRepository();
});

final weeklySummaryProvider =
    FutureProvider<List<HealthRecord>>((ref) async {
  final repository = ref.watch(weeklySummaryRepositoryProvider);
  return await repository.getLast7DaysRecords();
});


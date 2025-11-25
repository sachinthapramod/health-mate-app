import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/health_record_repository.dart';
import '../../data/models/health_record.dart';

final healthRecordRepositoryProvider = Provider<HealthRecordRepository>((ref) {
  return HealthRecordRepository();
});

final healthRecordsProvider = FutureProvider<List<HealthRecord>>((ref) async {
  final repository = ref.watch(healthRecordRepositoryProvider);
  return await repository.getAllRecords();
});

final todayRecordProvider = FutureProvider<HealthRecord?>((ref) async {
  final repository = ref.watch(healthRecordRepositoryProvider);
  return await repository.getTodayRecord();
});

final healthRecordNotifierProvider =
    StateNotifierProvider<HealthRecordNotifier, AsyncValue<List<HealthRecord>>>(
  (ref) {
    final repository = ref.watch(healthRecordRepositoryProvider);
    return HealthRecordNotifier(repository);
  },
);

class HealthRecordNotifier extends StateNotifier<AsyncValue<List<HealthRecord>>> {
  final HealthRecordRepository _repository;

  HealthRecordNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRecords();
  }

  Future<void> loadRecords() async {
    state = const AsyncValue.loading();
    try {
      final records = await _repository.getAllRecords();
      state = AsyncValue.data(records);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addRecord(HealthRecord record) async {
    try {
      await _repository.createRecord(record);
      await loadRecords();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateRecord(HealthRecord record) async {
    try {
      await _repository.updateRecord(record);
      await loadRecords();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteRecord(int id) async {
    try {
      await _repository.deleteRecord(id);
      await loadRecords();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> searchByDate(String date) async {
    state = const AsyncValue.loading();
    try {
      final records = await _repository.getRecordsByDate(date);
      state = AsyncValue.data(records);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}


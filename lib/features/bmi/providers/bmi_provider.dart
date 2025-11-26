import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bmi_repository.dart';
import '../data/bmi_model.dart';

final bmiRepositoryProvider = Provider<BMIRepository>((ref) {
  return BMIRepository();
});

final bmiHistoryProvider = FutureProvider<List<BMIRecord>>((ref) async {
  final repository = ref.watch(bmiRepositoryProvider);
  return await repository.getAllBMIHistory();
});

final bmiNotifierProvider =
    StateNotifierProvider<BMINotifier, AsyncValue<List<BMIRecord>>>(
  (ref) {
    final repository = ref.watch(bmiRepositoryProvider);
    return BMINotifier(repository);
  },
);

class BMINotifier extends StateNotifier<AsyncValue<List<BMIRecord>>> {
  final BMIRepository _repository;

  BMINotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final history = await _repository.getAllBMIHistory();
      state = AsyncValue.data(history);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> saveBMI(BMIRecord record) async {
    try {
      await _repository.saveBMI(record);
      await loadHistory();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteBMI(int id) async {
    try {
      await _repository.deleteBMI(id);
      await loadHistory();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}


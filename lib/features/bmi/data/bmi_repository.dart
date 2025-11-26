import '../../health_records/data/db/database_helper.dart';
import 'bmi_model.dart';

class BMIRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> saveBMI(BMIRecord record) async {
    try {
      return await _dbHelper.insertBMI(record.toMap());
    } catch (e) {
      throw Exception('Failed to save BMI: $e');
    }
  }

  Future<List<BMIRecord>> getAllBMIHistory() async {
    try {
      final maps = await _dbHelper.getAllBMIHistory();
      return maps.map((map) => BMIRecord.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get BMI history: $e');
    }
  }

  Future<int> deleteBMI(int id) async {
    try {
      return await _dbHelper.deleteBMI(id);
    } catch (e) {
      throw Exception('Failed to delete BMI: $e');
    }
  }
}


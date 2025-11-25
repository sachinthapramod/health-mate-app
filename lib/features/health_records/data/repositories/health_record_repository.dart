import '../db/database_helper.dart';
import '../models/health_record.dart';

class HealthRecordRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createRecord(HealthRecord record) async {
    try {
      return await _dbHelper.insert(record);
    } catch (e) {
      throw Exception('Failed to create record: $e');
    }
  }

  Future<List<HealthRecord>> getAllRecords() async {
    try {
      return await _dbHelper.getAllRecords();
    } catch (e) {
      throw Exception('Failed to get records: $e');
    }
  }

  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    try {
      return await _dbHelper.getRecordsByDate(date);
    } catch (e) {
      throw Exception('Failed to get records by date: $e');
    }
  }

  Future<HealthRecord?> getRecordById(int id) async {
    try {
      return await _dbHelper.getRecordById(id);
    } catch (e) {
      throw Exception('Failed to get record: $e');
    }
  }

  Future<int> updateRecord(HealthRecord record) async {
    try {
      if (record.id == null) {
        throw Exception('Record ID is required for update');
      }
      return await _dbHelper.update(record);
    } catch (e) {
      throw Exception('Failed to update record: $e');
    }
  }

  Future<int> deleteRecord(int id) async {
    try {
      return await _dbHelper.delete(id);
    } catch (e) {
      throw Exception('Failed to delete record: $e');
    }
  }

  Future<HealthRecord?> getTodayRecord() async {
    try {
      return await _dbHelper.getTodayRecord();
    } catch (e) {
      throw Exception('Failed to get today\'s record: $e');
    }
  }
}


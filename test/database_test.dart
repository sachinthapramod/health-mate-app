import 'package:flutter_test/flutter_test.dart';
import 'package:health_mate_app/features/health_records/data/db/database_helper.dart';
import 'package:health_mate_app/features/health_records/data/models/health_record.dart';

void main() {
  late DatabaseHelper dbHelper;

  setUp(() async {
    dbHelper = DatabaseHelper.instance;
    // Clean up before each test
    final db = await dbHelper.database;
    await db.delete('health_records');
  });

  tearDown(() async {
    await dbHelper.close();
  });

  group('Database Operations', () {
    test('should insert a health record', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await dbHelper.insert(record);
      expect(id, isNotNull);
      expect(id, greaterThan(0));
    });

    test('should retrieve all records', () async {
      final record1 = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final record2 = HealthRecord(
        date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        steps: 8000,
        calories: 2000,
        water: 1500,
      );

      await dbHelper.insert(record1);
      await dbHelper.insert(record2);

      final records = await dbHelper.getAllRecords();
      expect(records.length, equals(2));
    });

    test('should retrieve a record by id', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await dbHelper.insert(record);
      final retrieved = await dbHelper.getRecordById(id);

      expect(retrieved, isNotNull);
      expect(retrieved?.steps, equals(10000));
      expect(retrieved?.calories, equals(2500));
      expect(retrieved?.water, equals(2000));
    });

    test('should update a health record', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await dbHelper.insert(record);
      final updatedRecord = HealthRecord(
        id: id,
        date: record.date,
        steps: 12000,
        calories: 2800,
        water: 2500,
      );

      await dbHelper.update(updatedRecord);
      final retrieved = await dbHelper.getRecordById(id);

      expect(retrieved?.steps, equals(12000));
      expect(retrieved?.calories, equals(2800));
      expect(retrieved?.water, equals(2500));
    });

    test('should delete a health record', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await dbHelper.insert(record);
      await dbHelper.delete(id);

      final retrieved = await dbHelper.getRecordById(id);
      expect(retrieved, isNull);
    });

    test('should filter records by date', () async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      final record1 = HealthRecord(
        date: today.toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final record2 = HealthRecord(
        date: yesterday.toIso8601String(),
        steps: 8000,
        calories: 2000,
        water: 1500,
      );

      await dbHelper.insert(record1);
      await dbHelper.insert(record2);

      final todayRecords = await dbHelper.getRecordsByDate(today.toIso8601String());
      expect(todayRecords.length, equals(1));
      expect(todayRecords.first.steps, equals(10000));
    });
  });
}


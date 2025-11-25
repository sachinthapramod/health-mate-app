import 'package:flutter_test/flutter_test.dart';
import 'package:health_mate_app/features/health_records/data/repositories/health_record_repository.dart';
import 'package:health_mate_app/features/health_records/data/models/health_record.dart';
import 'package:health_mate_app/features/health_records/data/db/database_helper.dart';

void main() {
  late HealthRecordRepository repository;
  late DatabaseHelper dbHelper;

  setUp(() async {
    dbHelper = DatabaseHelper.instance;
    repository = HealthRecordRepository();
    // Clean up before each test
    final db = await dbHelper.database;
    await db.delete('health_records');
  });

  tearDown(() async {
    await dbHelper.close();
  });

  group('Repository CRUD Operations', () {
    test('should create a record', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await repository.createRecord(record);
      expect(id, isNotNull);
      expect(id, greaterThan(0));
    });

    test('should get all records', () async {
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

      await repository.createRecord(record1);
      await repository.createRecord(record2);

      final records = await repository.getAllRecords();
      expect(records.length, greaterThanOrEqualTo(2));
    });

    test('should get a record by id', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await repository.createRecord(record);
      final retrieved = await repository.getRecordById(id);

      expect(retrieved, isNotNull);
      expect(retrieved?.steps, equals(10000));
    });

    test('should update a record', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await repository.createRecord(record);
      final updatedRecord = HealthRecord(
        id: id,
        date: record.date,
        steps: 12000,
        calories: 2800,
        water: 2500,
      );

      await repository.updateRecord(updatedRecord);
      final retrieved = await repository.getRecordById(id);

      expect(retrieved?.steps, equals(12000));
    });

    test('should delete a record', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      final id = await repository.createRecord(record);
      await repository.deleteRecord(id);

      final retrieved = await repository.getRecordById(id);
      expect(retrieved, isNull);
    });

    test('should throw error when updating record without id', () async {
      final record = HealthRecord(
        date: DateTime.now().toIso8601String(),
        steps: 10000,
        calories: 2500,
        water: 2000,
      );

      expect(
        () => repository.updateRecord(record),
        throwsA(isA<Exception>()),
      );
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

      await repository.createRecord(record1);
      await repository.createRecord(record2);

      final todayRecords = await repository.getRecordsByDate(today.toIso8601String());
      expect(todayRecords.length, equals(1));
    });
  });
}


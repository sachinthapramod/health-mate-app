import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_records.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE health_records (
        id $idType,
        date $textType,
        steps $intType,
        calories $intType,
        water $intType
      )
    ''');

    // Insert dummy data on first launch
    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    final now = DateTime.now();
    final dummyRecords = [
      HealthRecord(
        date: now.subtract(const Duration(days: 2)).toIso8601String(),
        steps: 8500,
        calories: 2200,
        water: 2000,
      ),
      HealthRecord(
        date: now.subtract(const Duration(days: 1)).toIso8601String(),
        steps: 10200,
        calories: 2400,
        water: 2500,
      ),
      HealthRecord(
        date: now.toIso8601String(),
        steps: 7500,
        calories: 2000,
        water: 1800,
      ),
    ];

    for (var record in dummyRecords) {
      await db.insert('health_records', record.toMap());
    }
  }

  Future<int> insert(HealthRecord record) async {
    final db = await database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    const orderBy = 'date DESC';
    final result = await db.query('health_records', orderBy: orderBy);
    return result.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'date DESC',
    );
    return result.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<HealthRecord?> getRecordById(int id) async {
    final db = await database;
    final maps = await db.query(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return HealthRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(HealthRecord record) async {
    final db = await database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<HealthRecord?> getTodayRecord() async {
    final db = await database;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day).toIso8601String();
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
    
    final maps = await db.query(
      'health_records',
      where: 'date >= ? AND date <= ?',
      whereArgs: [todayStart, todayEnd],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return HealthRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}


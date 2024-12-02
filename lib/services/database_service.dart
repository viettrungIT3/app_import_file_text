import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'files_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE files (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_name TEXT NOT NULL,
            content TEXT NOT NULL,
            saved_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Insert a new file record
  Future<int> insertFile(String fileName, String content) async {
    final db = await database;
    return await db.insert(
      'files',
      {
        'file_name': fileName,
        'content': content,
        'saved_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Get the count of files saved for a specific date
  Future<int> getFileCountForDate(String date) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) AS count FROM files
      WHERE saved_at LIKE '%$date%'
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get all saved files
  Future<List<Map<String, dynamic>>> getFiles() async {
    final db = await database;
    return await db.query(
      'files',
      orderBy: 'saved_at DESC',
    );
  }

  /// Delete a file by its ID
  Future<int> deleteFile(int id) async {
    final db = await database;
    return await db.delete(
      'files',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

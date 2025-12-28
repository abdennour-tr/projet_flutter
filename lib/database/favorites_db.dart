import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritesDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'favorites.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            rating REAL,
            category TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'favorites',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return db.query('favorites');
  }

  static Future<bool> exists(String id) async {
    final db = await database;
    final res = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty;
  }
}

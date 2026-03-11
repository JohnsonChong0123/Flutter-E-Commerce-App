import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;
  static const _version = 1;
  static const _dbName = 'app_cache.db';

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb({String? path}) async {
    final dbPath = path ?? join(await getDatabasesPath(), _dbName);
    return openDatabase(
      dbPath,
      version: _version,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  static const _createProductSummaryTable = '''
    CREATE TABLE product_summary (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      initial_prices REAL NOT NULL,
      final_prices REAL NOT NULL,
      image_url TEXT NOT NULL,
      rating REAL NOT NULL,
      reviews_count INTEGER NOT NULL,
      cached_at INTEGER NOT NULL
    )
  ''';

  static const _createProductDetailsTable = '''
    CREATE TABLE product_details (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      initial_prices REAL NOT NULL,
      final_prices REAL NOT NULL,
      image_url TEXT NOT NULL,
      cached_at INTEGER NOT NULL,
      FOREIGN KEY (id) REFERENCES product_summary (id)
    )
  ''';

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createProductSummaryTable);
    await db.execute(_createProductDetailsTable);
  }

  @visibleForTesting
  static Future<void> initForTest() async {
    _db = await _initDb(path: inMemoryDatabasePath);
  }

  @visibleForTesting
  static Future<void> reset() async {
    await _db?.close();
    _db = null;
  }
}

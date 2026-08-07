import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_dev/sqflite_dev.dart';

class AppDatabase {
  static Database? _db;
  static const _version = 3;
  static const _dbName = 'app_cache.db';

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb({String? path}) async {
    final dbPath = path ?? join(await getDatabasesPath(), _dbName);
    final db = await openDatabase(
      dbPath,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );

    if (kDebugMode && path != inMemoryDatabasePath) {
      db.enableWorkbench(
        webDebug: true,
        webDebugPort: 8080,
        webDebugName: 'AppCacheDB',
      );
    }

    return db;
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS product_summary');
      await db.execute('DROP TABLE IF EXISTS product_details');
      await db.execute(_createProductSummaryTable);
      await db.execute(_createProductDetailsTable);
    }

    if (oldVersion < 3) {
      await db.execute(_createCartCacheTable);
    }
  }

  static const _createProductSummaryTable = '''
    CREATE TABLE product_summary (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      initial_prices TEXT,
      final_prices TEXT NOT NULL,
      image_url TEXT NOT NULL,
      cached_at INTEGER NOT NULL
    )
  ''';

  static const _createProductDetailsTable = '''
    CREATE TABLE product_details (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      initial_prices TEXT,
      final_prices TEXT NOT NULL,
      image_url TEXT NOT NULL,
      additional_images TEXT NOT NULL, 
      localized_aspects TEXT NOT NULL,
      shipping_options TEXT NOT NULL,
      cached_at INTEGER NOT NULL
    )
  ''';

  static const _createCartCacheTable = '''
    CREATE TABLE cart_cache (
      id TEXT PRIMARY KEY,
      cart_json TEXT NOT NULL,
      cached_at INTEGER NOT NULL
    )
  ''';

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createProductSummaryTable);
    await db.execute(_createProductDetailsTable);
    await db.execute(_createCartCacheTable);
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

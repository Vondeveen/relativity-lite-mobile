import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDb {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'relativity_lite.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE documents (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          path TEXT,
          mime TEXT,
          text TEXT,
          added_at TEXT,
          privilege INTEGER,
          responsive INTEGER NULL,
          issues TEXT
        );
      ''');
      await db.execute('CREATE INDEX idx_text ON documents(text);');
    });
    return _db!;
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(
      path,
      version: 3, // 데이터베이스 버전 업데이트
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase, // 테이블 업그레이드 함수 추가
    );
  }

  void _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 기존 버전이 2보다 작은 경우 'your_table' 테이블에 'title' 컬럼 추가
      await db.execute('ALTER TABLE your_table ADD COLUMN title TEXT');
    }

    if (oldVersion < 3) {
      // 기존 버전이 3보다 작은 경우 'your_table' 테이블에 'content' 컬럼 추가
      await db.execute('ALTER TABLE your_table ADD COLUMN content TEXT');
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE your_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<void> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert('your_table', row);
  }

  Future<void> delete(int id) async {
    Database db = await instance.database;
    await db.delete('your_table', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(int id, String table, Map<String, dynamic> data) async {
    Database db = await instance.database;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query('your_table');
  }
}

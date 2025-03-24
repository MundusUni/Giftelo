import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'usuarios.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            layout TEXT,
            max_usos INTEGER,
            usos INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> addUser(String name, String phone, String layout, int maxUsos) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'phone': phone,
      'layout': layout,
      'max_usos': maxUsos,
      'usos': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}

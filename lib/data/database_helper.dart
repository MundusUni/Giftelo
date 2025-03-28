import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

  
  //Este código é para ser ativado com o código abaixo no lista_de_cadastrados.dart:
  /*
DatabaseHelper dbHelper = DatabaseHelper();
await dbHelper.dropUsersTable();
  */
  Future<void> dropUsersTable() async {
  final db = await database;
  await db.execute('DROP TABLE IF EXISTS users');
  // Recriar a tabela após dropar
  await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      celular TEXT,
      layout TEXT,
      usos INTEGER DEFAULT 0,
      max_usos INTEGER
    )
  ''');
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
            celular TEXT,
            layout TEXT,
            usos INTEGER DEFAULT 0,
            max_usos INTEGER
          )
        ''');
      },
    );
  }


  Future<int> addUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user,conflictAlgorithm: ConflictAlgorithm.replace);
  }


/*
  Future<int> addUser(String name, String phone, String layout, int maxUsos, int usos) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'phone': phone,
      'layout': layout,
      'usos': usos,
      'max_usos': maxUsos,
    });
  }
*/

Future<int> deleteUser(int id) async {
  final db = await database;
  return await db.delete('users', where: 'id = ?', whereArgs: [id]);
}


Future<int> updateUser(Map<String, dynamic> user) async {
  final db = await database;
  return await db.update(
    'users',
    user,
    where: 'id = ?',
    whereArgs: [user['id']],
  );
}

/*
Future<int> updateUser(int id, String name, String phone, String layout, int maxUsos, int usos) async {
  final db = await database;
  return await db.update(
    'users',
    {'name': name, 'phone': phone, 'layout': layout, 'max_usos': maxUsos, 'usos': usos},
    where: 'id = ?',
    whereArgs: [id],
  );
}
*/


Future<List<Map<String, dynamic>>> getAllUsers() async {
  final db = await database;
  // Query para retornar todos os usuários
  List<Map<String, dynamic>> users = await db.query('users');

  // Ajuste para garantir que a estrutura dos dados retorne como esperado
  return users.map((user) {
    return {
      'id': user['id'], // id do usuário
      'name': user['name'], // nome do usuário
      'celular': user['celular'], // telefone do usuário
      'layout': user['layout'], // número do layout
      'usos': user['usos'], // número de usos
      'max_usos': user['max_usos'], // número máximo de usos
    };
  }).toList();
}
}

/*
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}
*/







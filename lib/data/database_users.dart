 import 'package:sqflite/sqflite.dart';
 import 'package:path/path.dart';
 import 'package:sqflite_common_ffi/sqflite_ffi.dart';
 
 class DatabaseUser {
   static final DatabaseUser _instance = DatabaseUser._internal();
   factory DatabaseUser() => _instance;
   DatabaseUser._internal();
 
   static Database? _userDatabase;
 
   Future<Database> get userDatabase async {
     if (_userDatabase != null) return _userDatabase!;
     _userDatabase = await _initDatabase();
     return _userDatabase!;
   }
 
 
   //Este código é para ser ativado com o código abaixo no lista_de_cadastrados.dart:
   /*
 DatabaseHelper dbHelper = DatabaseHelper();
 await dbHelper.dropUsersTable();
   */
   Future<void> dropUsersTable() async {
   final db = await userDatabase;
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
     final db = await userDatabase;
     return await db.insert('users', user,conflictAlgorithm: ConflictAlgorithm.replace);
   }
 
 Future<int> deleteUser(int id) async {
   final db = await userDatabase;
   return await db.delete('users', where: 'id = ?', whereArgs: [id]);
 }
 
 
 Future<int> updateUser(Map<String, dynamic> user) async {
   final db = await userDatabase;
   return await db.update(
     'users',
     user,
     where: 'id = ?',
     whereArgs: [user['id']],
   );
 }
 
 Future<List<Map<String, dynamic>>> getAllUsers() async {
   final db = await userDatabase;
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
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  // Singleton: garante que apenas uma instância de DatabaseHelper será criada.
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _layoutDatabase;
  static Database? _database;




  // Getter para o banco de dados dos layouts.
  Future<Database> get layoutDatabase async {
    if (_layoutDatabase != null) return _layoutDatabase!;
    _layoutDatabase = await _initLayoutDatabase();
    return _layoutDatabase!;
  }

  // Getter para o banco de dados dos usuários.
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



  // Inicializa o banco de dados dos layouts.
  Future<Database> _initLayoutDatabase() async {
    final path = await getDatabasesPath();
    final layoutDatabasePath = join(path, 'layouts.db');
    return await openDatabase(
      layoutDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        // Cria a tabela 'layout_table' no banco de dados dos layouts.
        await db.execute('''
          CREATE TABLE layout_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name_layout TEXT DEFAULT '',
            upper_text TEXT DEFAULT '',
            lower_text TEXT DEFAULT '',
            extra_phrase TEXT DEFAULT '',
            upper_text_font TEXT DEFAULT 'arial',
            lower_text_font TEXT DEFAULT 'arial',
            logo_circle_size INTEGER DEFAULT 70,
            upper_text_color INTEGER DEFAULT 4278190080,
            lower_text_color INTEGER DEFAULT 4278190080,
            card_color INTEGER DEFAULT 4278190335,
            logo_circle_color INTEGER DEFAULT 4294967295,
            circle_color INTEGER DEFAULT 4294967295,
            stamp_color INTEGER DEFAULT 4294967040,
            stamp_icon TEXT DEFAULT 'Icons.local_pizza', 
            logo BLOB
          )
        ''');
      },
    );
  }

  // Inicializa o banco de dados dos usuários.
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'usuarios.db');
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        // Cria a tabela 'users' no banco de dados principal.
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



  // Adiciona uma nova entrada na tabela 'layout_table' do banco de dados dos layouts.
  Future<int> addLayout(Map<String, dynamic> layout) async {
    final db = await layoutDatabase;
    return await db.insert('layout_table', layout, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Adiciona uma nova entrada na tabela 'users' do banco de dados dos Usuários.
  Future<int> addUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }



  // Atualiza uma entrada existente na tabela 'layout_table' do banco de dados dos layouts.
  Future<int> updateLayout(Map<String, dynamic> layout) async {
    final db = await layoutDatabase;
    return await db.update(
      'layout_table',
      layout,
      where: 'id = ?',
      whereArgs: [layout['id']],
    );
  }

  // Atualiza uma entrada existente na tabela 'users' do banco de dados dos usuários.
Future<int> updateUser(Map<String, dynamic> user) async {
  final db = await database;
  return await db.update(
    'users',
    user,
    where: 'id = ?',
    whereArgs: [user['id']],
  );
}



  // Exclui uma entrada da tabela 'layout_table' do banco de dados dos layouts.
  Future<int> deleteLayout(int id) async {
    final db = await layoutDatabase;
    return await db.delete('layout_table', where: 'id = ?', whereArgs: [id]);
  }

  // Exclui uma entrada da tabela 'users' do banco de dados dos usuários.
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }



  // Retorna todas as entradas da tabela 'layout_table' do banco de dados dos layouts.
  Future<List<Map<String, dynamic>>> getAllLayouts() async {
    final db = await layoutDatabase;
    // Query para retornar todos os layouts
    List<Map<String, dynamic>> layouts = await db.query('layout_table');
    // Ajuste para garantir que a estrutura dos dados retorne como esperado
    return layouts.map((layout) {
      return {
	      'id': layout['id'], // id do usuário
        'name_layout': layout['name_layout'], // nome do layout
        'upper_text': layout['upper_text'], // frase acima dos stamps no card
        'lower_text': layout['lower_text'], // frase abaixo dos stamps no card
        'extra_phrase': layout['extra_phrase'], // frase extra que vai junto com o card no messenger
        'upper_text_font': layout['upper_text_font'], // fonte do texto acima dos stamps no card
        'lower_text_font': layout['lower_text_font'], // fonte do texto abaixo dos stamps no card
        'logo_circle_size': layout['logo_circle_size'], // tamanho do círculo atrás da logo
        'upper_text_color': layout['upper_text_color'], // cor do texto acima dos stamps no card
        'lower_text_color': layout['lower_text_color'], // cor do texto abaixo dos stamps no card
        'card_color': layout['card_color'], // cor do cartão
        'logo_circle_color': layout['logo_circle_color'], // cor do círculo atrás da logo
        'circle_color': layout['circle_color'], // cor dos círculos atrás dos stamps
        'stamp_color': layout['stamp_color'], // cor dos stamps
        'stamp_icon': layout['stamp'], // ícone utilizado como stamp
        'logo': layout['logo'], // imagem da logo do cliente

      };
    }).toList();
  }

  // Retorna todas as entradas da tabela 'users' do banco de dados dos usuários.
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
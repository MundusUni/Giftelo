import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:typed_data';

class DatabaseLayout {
  // Singleton: garante que apenas uma instância de DatabaseHelper será criada.
  static final DatabaseLayout _instance = DatabaseLayout._internal();
  factory DatabaseLayout() => _instance;
  DatabaseLayout._internal();

  static Database? _layoutDatabase;

  // Getter para o banco de dados dos layouts.
  Future<Database> get layoutDatabase async {
    if (_layoutDatabase != null) return _layoutDatabase!;
    _layoutDatabase = await _initLayoutDatabase();
    return _layoutDatabase!;
  }

//Verifica se a tabela foi Criada Corretamente
  Future<void> checkTableExists() async {
    final db = await DatabaseLayout().layoutDatabase;
    final result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='layout_table'");
    if (result.isNotEmpty) {
      print('Tabela layout_table existe.');
    } else {
      print('Tabela layout_table não foi criada.');
    }
  }
  

///// Código para adicionar uma nova coluna
///
Future<void> addLogoSizeColumnIfNotExists() async {
  final db = await layoutDatabase;

  // Primeiro, verifica se a coluna já existe
  final result = await db.rawQuery("PRAGMA table_info(layout_table)");

  final column2Exists = result.any((column) => column['name'] == 'icon_size');
  final columnExists = result.any((column) => column['name'] == 'circle_size');

  if (!column2Exists) {
    // Se a coluna não existir, adiciona
    await db.execute("ALTER TABLE layout_table ADD COLUMN icon_size INTEGER DEFAULT 35");
    print('Coluna icon_size adicionada com sucesso.');
  } else {
    print('A coluna icon_size já existe.');
  }

  if (!columnExists) {
    // Se a coluna não existir, adiciona
    await db.execute("ALTER TABLE layout_table ADD COLUMN circle_size INTEGER DEFAULT 35");
    print('Coluna circle_size adicionada com sucesso.');
  } else {
    print('A coluna circle_size já existe.');
  }
}
///
/////


///// Código para Deletar e Recriar o banco de dados do Layout
///
Future<void> resetLayoutDatabase() async {
  final path = await getDatabasesPath();
  final layoutDatabasePath = join(path, 'layouts.db');

  // Deleta o banco de dados existente
  await deleteDatabase(layoutDatabasePath);

  // Recria o banco de dados chamando a função de inicialização
  await _initLayoutDatabase();
}
///
/////



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
            stamp_icon INTEGER DEFAULT 58272, 
            stamp_background INTEGER DEFAULT 57699,
            number_of_circles INTEGER DEFAULT 1,
            logo_size INTEGER DEFAULT 0,
            circle_size INTEGER DEFAULT 35,
            icon_size INTEGER DEFAULT 35
          )
        ''');
      },
    );
  }

  Future<Map<String, dynamic>> getDefaultValues(String tableName) async {
    final db = await layoutDatabase;
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    // Extrai os valores padrão (dflt_value) das colunas
    final defaultValues = <String, dynamic>{};
    for (var column in result) {
      final columnName = column['name'] as String;
      final defaultValue = column['dflt_value'];
      if (defaultValue != null) {
        // Converte o valor padrão para o tipo correto, se necessário
        defaultValues[columnName] = _parseDefaultValue(defaultValue);
      }
    }
    return defaultValues;
  }

  // Método auxiliar para converter o valor padrão do SQLite para o tipo correto
  dynamic _parseDefaultValue(dynamic defaultValue) {
    if (defaultValue is String && defaultValue.startsWith("'") && defaultValue.endsWith("'")) {
      return defaultValue.substring(1, defaultValue.length - 1); // Remove aspas simples
    }
    if (defaultValue == 'NULL') {
      return null;
    }
    if (defaultValue is String && double.tryParse(defaultValue) != null) {
      return double.parse(defaultValue); // Converte para número, se aplicável
    }
    return defaultValue; // Retorna o valor como está
  }






  Future<List<Map<String, dynamic>>> getAllLayout() async {
    final db = await layoutDatabase;
    return await db.query(
      'layout_table',
      columns: ['name_layout'], // Busca apenas a coluna name_layout
    );
  }

  Future<Map<String, dynamic>?> getLayoutByName(String nameLayout) async {
    final db = await layoutDatabase;
    final result = await db.query(
      'layout_table',
      where: 'name_layout = ?',
      whereArgs: [nameLayout],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  //Atualizar um Layout Existente
  Future<void> updateLayout({
    required String nameLayout,
    required String upperText,
    required String lowerText,
    required String exampleText,
    required int upperTextColor,
    required int lowerTextColor,
    required int logoCircleSize,
    required int cardColor,
    required int logoCircleColor,
    required int circleColor,
    required int stampColor,
    required int stampIcon,
    required int stampBackground,
    required int numberOfCircles,
    required int logoSize,
    required int circleSize,
    required int iconSize,
  }) async {
    final db = await layoutDatabase;
    await db.update(
      'layout_table',
      {
        'upper_text': upperText,
        'lower_text': lowerText,
        'extra_phrase': exampleText,
        'upper_text_color': upperTextColor,
        'lower_text_color': lowerTextColor,
        'logo_circle_size': logoCircleSize,
        'card_color': cardColor,
        'logo_circle_color': logoCircleColor,
        'circle_color': circleColor,
        'stamp_color': stampColor,
        'stamp_icon': stampIcon,
        'stamp_background': stampBackground,
        'number_of_circles': numberOfCircles,
        'logo_size': logoSize,
        'circle_size': circleSize,
        'icon_size': iconSize,
      },
      where: 'name_layout = ?',
      whereArgs: [nameLayout],
    );
  }

  Future<void> insertLayout({
    required String nameLayout,
    required String upperText,
    required String lowerText,
    required String exampleText,
    required int upperTextColor,
    required int lowerTextColor,
    required int logoCircleSize,
    required int cardColor,
    required int logoCircleColor,
    required int circleColor,
    required int stampColor,
    required int stampIcon,
    required int stampBackground,
    required int numberOfCircles,
    required int logoSize,
    required int circleSize,
    required int iconSize,
  }) async {
    final db = await layoutDatabase;
    await db.insert(
      'layout_table',
      {
        'name_layout': nameLayout,
        'upper_text': upperText,
        'lower_text': lowerText,
        'extra_phrase': exampleText,
        'upper_text_color': upperTextColor,
        'lower_text_color': lowerTextColor,
        'logo_circle_size': logoCircleSize,
        'card_color': cardColor,
        'logo_circle_color': logoCircleColor,
        'circle_color': circleColor,
        'stamp_color': stampColor,
        'stamp_icon': stampIcon,
        'stamp_background': stampBackground,
        'number_of_circles': numberOfCircles,
        'logo_size': logoSize,
        'circle_size': circleSize,
        'icon_size': iconSize,
      },
    );
  }




  // Adiciona uma nova entrada na tabela 'layout_table' do banco de dados dos layouts.
  Future<int> addLayout(Map<String, dynamic> layout) async {
    final db = await layoutDatabase;
    return await db.insert('layout_table', layout, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Atualiza uma entrada existente na tabela 'layout_table' do banco de dados dos layouts.
  Future<int> updateLayoutBKP(Map<String, dynamic> layout) async {
    final db = await layoutDatabase;
    return await db.update(
      'layout_table',
      layout,
      where: 'id = ?',
      whereArgs: [layout['id']],
    );
  }

  // Exclui uma entrada da tabela 'layout_table' do banco de dados dos layouts.
  Future<int> deleteLayout(int id) async {
    final db = await layoutDatabase;
    return await db.delete('layout_table', where: 'id = ?', whereArgs: [id]);
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
        'stamp_icon': layout['stamp_icon'], // ícone utilizado como stamp
        'stamp_background': layout['stamp_background'], // fundo do stamp
        'number_of_circles': layout['number_of_circles'], // número de círculos atrás dos stamps
        'logo_size': layout['logo_size'], // tamanho da logo do cliente
        'circle_size': layout['circle_size'], // tamanho dos círculos atrás dos stamps
        'icon_size': layout['icon_size'], // tamanho do ícone do stamp
      };
    }).toList();
  }

    // Retorna todos os nomes presentes na coluna 'name_layout'
  Future<List<String>> getAllNames() async {
    final db = await layoutDatabase;
    final result = await db.query(
      'layout_table',
      columns: ['name_layout'],
    );

    // Transforma os resultados em uma lista de strings
    return result.map((row) => row['name_layout'] as String).toList();
  }

}
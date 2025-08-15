import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class DatabaseLayout {
  // Singleton: garante que apenas uma instância de DatabaseHelper será criada.
  static final DatabaseLayout _instance = DatabaseLayout._internal();
  factory DatabaseLayout() => _instance;
  DatabaseLayout._internal();

  static Database? _layoutDatabase;

  // Métodos helper para converter ícones/imagens para string e vice-versa
  String iconToString(dynamic icon) {
    if (icon is IconData) {
      return 'icon:${icon.codePoint}';
    } else if (icon is String) {
      return 'asset:$icon';
    }
    return 'icon:57699'; // fallback para ícone padrão (círculo)
  }

  dynamic stringToIcon(String iconString) {
    if (iconString.startsWith('icon:')) {
      final codePoint = int.tryParse(iconString.substring(5));
      if (codePoint != null) {
        return IconData(codePoint, fontFamily: 'MaterialIcons');
      }
    } else if (iconString.startsWith('asset:')) {
      return iconString.substring(6);
    }
    return IconData(0xe163, fontFamily: 'MaterialIcons'); // fallback
  }

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
  try {
    final path = await getDatabasesPath();
    final layoutDatabasePath = join(path, 'layouts.db');

    // Deleta o banco de dados existente
    await deleteDatabase(layoutDatabasePath);

    // Recria o banco de dados chamando a função de inicialização
    await _initLayoutDatabase();
  } catch (e) {
    print('Erro ao resetar banco de dados: $e');
  }
}
///
/////



  // Inicializa o banco de dados dos layouts.
  Future<Database> _initLayoutDatabase() async {
    final path = await getDatabasesPath();
    final layoutDatabasePath = join(path, 'layouts.db');
    return await openDatabase(
      layoutDatabasePath,
      version: 2, // Incrementei a versão para atualizar a estrutura
      onCreate: (db, version) async {
        // Cria a tabela 'layout_table' no banco de dados dos layouts.
        await db.execute('''
          CREATE TABLE layout_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name_layout TEXT DEFAULT '',
            upper_text TEXT DEFAULT '',
            lower_text TEXT DEFAULT '',
            logo_circle_size INTEGER DEFAULT 70,
            upper_text_color INTEGER DEFAULT 4278190080,
            lower_text_color INTEGER DEFAULT 4278190080,
            card_color INTEGER DEFAULT 4278190335,
            logo_circle_color INTEGER DEFAULT 4294967295,
            circle_color INTEGER DEFAULT 4294967295,
            stamp_color INTEGER DEFAULT 4294967040,
            stamp_icon TEXT DEFAULT 'icon:58272',
            stamp_background TEXT DEFAULT 'icon:57699',
            number_of_circles INTEGER DEFAULT 1,
            logo_size INTEGER DEFAULT 0,
            circle_size INTEGER DEFAULT 35,
            icon_size INTEGER DEFAULT 35
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migra dados existentes de INTEGER para TEXT
          await db.execute('ALTER TABLE layout_table ADD COLUMN stamp_icon_temp TEXT');
          await db.execute('ALTER TABLE layout_table ADD COLUMN stamp_background_temp TEXT');
          
          // Converte dados existentes
          await db.execute('''
            UPDATE layout_table 
            SET stamp_icon_temp = 'icon:' || CAST(stamp_icon AS TEXT),
                stamp_background_temp = 'icon:' || CAST(stamp_background AS TEXT)
          ''');
          
          // Remove colunas antigas e renomeia as novas
          await db.execute('ALTER TABLE layout_table DROP COLUMN stamp_icon');
          await db.execute('ALTER TABLE layout_table DROP COLUMN stamp_background');
          await db.execute('ALTER TABLE layout_table RENAME COLUMN stamp_icon_temp TO stamp_icon');
          await db.execute('ALTER TABLE layout_table RENAME COLUMN stamp_background_temp TO stamp_background');
        }
      },
    );
  }

  Future<Map<String, dynamic>> getDefaultValues(String tableName) async {
    try {
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
      } catch (e) {
      print('Erro ao obter valores padrão: $e');
      return {};
    }
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



  // Extrai o codePoint de uma string de ícone
  int getIconCodePoint(String iconString) {
    if (iconString.startsWith('icon:')) {
      final codePoint = int.tryParse(iconString.substring(5));
      if (codePoint != null) {
        return codePoint;
      }
    }
    return 57699; // fallback para ícone padrão (círculo)
  }

  // Converte string para IconData (para uso na UI)
  IconData getIconData(String iconString) {
    if (iconString.startsWith('icon:')) {
      final codePoint = int.tryParse(iconString.substring(5));
      if (codePoint != null) {
        return IconData(codePoint, fontFamily: 'MaterialIcons');
      }
    }
    return IconData(57699, fontFamily: 'MaterialIcons'); // fallback
  }





  Future<List<Map<String, dynamic>>> getAllLayout() async {
    try {
      final db = await layoutDatabase;
      return await db.query(
        'layout_table',
        columns: ['name_layout'], // Busca apenas a coluna name_layout
      );
    }
    catch (e) {
      print('Erro ao buscar todos os layouts: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getLayoutByName(String name) async {
    final db = await layoutDatabase;
    final List<Map<String, dynamic>> maps = await db.query(
      'layouts',
      where: 'name_layout = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      final layoutMap = maps.first;

      return {
        ...layoutMap,
        'stamp_icon': stringToIcon(layoutMap['stamp_icon']),
        'stamp_background': stringToIcon(layoutMap['stamp_background']),
      };
    } else {
      return null;
    }
  }


  //Atualizar um Layout Existente
  Future<void> updateLayout({
    required String nameLayout,
    required String upperText,
    required String lowerText,
    //required String exampleText,
    required int upperTextColor,
    required int lowerTextColor,
    required int logoCircleSize,
    required int cardColor,
    required int logoCircleColor,
    required int circleColor,
    required int stampColor,
    required dynamic stampIcon,
    required dynamic stampBackground,
    required int numberOfCircles,
    required int logoSize,
    required int circleSize,
    required int iconSize,
  }) async {
    try {
      final db = await layoutDatabase;
      await db.update(
        'layout_table',
        {
          'upper_text': upperText,
          'lower_text': lowerText,
          'upper_text_color': upperTextColor,
          'lower_text_color': lowerTextColor,
          'logo_circle_size': logoCircleSize,
          'card_color': cardColor,
          'logo_circle_color': logoCircleColor,
          'circle_color': circleColor,
          'stamp_color': stampColor,
          'stamp_icon': iconToString(stampIcon), // Converte para string
          'stamp_background': iconToString(stampBackground), // Converte para string
          'number_of_circles': numberOfCircles,
          'logo_size': logoSize,
          'circle_size': circleSize,
          'icon_size': iconSize,
        },
        where: 'name_layout = ?',
        whereArgs: [nameLayout],
      );
    } catch (e) {
      print('Erro ao atualizar layout "$nameLayout": $e');
    }
  }

  Future<void> insertLayout({
    required String nameLayout,
    required String upperText,
    required String lowerText,
    //required String exampleText,
    required int upperTextColor,
    required int lowerTextColor,
    required int logoCircleSize,
    required int cardColor,
    required int logoCircleColor,
    required int circleColor,
    required int stampColor,
    required dynamic stampIcon,
    required dynamic stampBackground,
    required int numberOfCircles,
    required int logoSize,
    required int circleSize,
    required int iconSize,
  }) async {
    try {
      final db = await layoutDatabase;
      await db.insert(
        'layout_table',
        {
          'name_layout': nameLayout,
          'upper_text': upperText,
          'lower_text': lowerText,
          'upper_text_color': upperTextColor,
          'lower_text_color': lowerTextColor,
          'logo_circle_size': logoCircleSize,
          'card_color': cardColor,
          'logo_circle_color': logoCircleColor,
          'circle_color': circleColor,
          'stamp_color': stampColor,
          'stamp_icon': iconToString(stampIcon),
          'stamp_background': iconToString(stampBackground),
          'number_of_circles': numberOfCircles,
          'logo_size': logoSize,
          'circle_size': circleSize,
          'icon_size': iconSize,
        },
      );
    } catch (e) {
      print('Erro ao inserir layout "$nameLayout": $e');
    }
  }




  // Adiciona uma nova entrada na tabela 'layout_table' do banco de dados dos layouts.
  Future<int> addLayout(Map<String, dynamic> layout) async {
    try {
      final db = await layoutDatabase;
      return await db.insert('layout_table', layout, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Erro ao adicionar layout: $e');
      return -1;
    }
  }

  // Atualiza uma entrada existente na tabela 'layout_table' do banco de dados dos layouts.
  Future<int> updateLayoutBKP(Map<String, dynamic> layout) async {
    try {
      final db = await layoutDatabase;
      return await db.update(
        'layout_table',
        layout,
        where: 'id = ?',
        whereArgs: [layout['id']],
      );
    } catch (e) {
      print('Erro ao atualizar layout: $e');
      return -1;
    }
  }

  // Exclui uma entrada da tabela 'layout_table' do banco de dados dos layouts.
  Future<int> deleteLayout(int id) async {
    try {
      final db = await layoutDatabase;
      return await db.delete('layout_table', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Erro ao deletar layout: $e');
      return -1;
    }
  }

  // Retorna todas as entradas da tabela 'layout_table' do banco de dados dos layouts.
  Future<List<Map<String, dynamic>>> getAllLayouts() async {
    try {
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
          'logo_circle_size': layout['logo_circle_size'], // tamanho do círculo atrás da logo
          'upper_text_color': layout['upper_text_color'], // cor do texto acima dos stamps no card
          'lower_text_color': layout['lower_text_color'], // cor do texto abaixo dos stamps no card
          'card_color': layout['card_color'], // cor do cartão
          'logo_circle_color': layout['logo_circle_color'], // cor do círculo atrás da logo
          'circle_color': layout['circle_color'], // cor dos círculos atrás dos stamps
          'stamp_color': layout['stamp_color'], // cor dos stamps
          'stamp_icon': stringToIcon(layout['stamp_icon']), // ícone utilizado como stamp
          'stamp_background': stringToIcon(layout['stamp_background']), // fundo do stamp
          'number_of_circles': layout['number_of_circles'], // número de círculos atrás dos stamps
          'logo_size': layout['logo_size'], // tamanho da logo do cliente
          'circle_size': layout['circle_size'], // tamanho dos círculos atrás dos stamps
          'icon_size': layout['icon_size'], // tamanho do ícone do stamp
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar todos os layouts: $e');
      return [];
    }
  }

    // Retorna todos os nomes presentes na coluna 'name_layout'
    Future<List<String>> getAllNames() async {
      try {
        final db = await layoutDatabase;
        final result = await db.query(
          'layout_table',
          columns: ['name_layout'],
        );

        // Transforma os resultados em uma lista de strings
        return result.map((row) => row['name_layout'] as String).toList();
      } catch (e) {
        print('Erro ao buscar nomes dos layouts: $e');
        return [];
      }
    }

}
import 'package:flutter/material.dart';
import 'layout_dos_cartoes.dart'; // Importa o layout_dos_cartoes.dart
import '../data/database_layout.dart'; // Importa o database_helper.dart

class LayoutStart extends StatefulWidget {
  const LayoutStart({super.key});

  @override
  State<LayoutStart> createState() => _LayoutStartState();
}

class _LayoutStartState extends State<LayoutStart> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Início'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Botão para resetar banco de dados
            ElevatedButton(
              onPressed: () async {
                await DatabaseLayout().resetLayoutDatabase();
                print('Banco de dados layouts.db foi resetado e recriado.');
              },
              child: const Text('Resetar Banco de Dados'),
            ),
            //Botão de Novo
            ElevatedButton(
              onPressed: () async {
                // Obtém os valores DEFAULT da tabela 'layout_table'
                final defaultValues = await DatabaseLayout().getDefaultValues('layout_table');
                // Navega para o layout_dos_cartoes.dart com os valores DEFAULT
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LayoutDosCartoes(
                      // Passa os valores padrão para o LayoutDosCartoes
                      stampCount: 1,
                      numberOfCircles: (defaultValues['number_of_circles'] == null || defaultValues['number_of_circles'] == 0) ? 1 : (defaultValues['number_of_circles'] is double ? (defaultValues['number_of_circles'] as double).toInt() : (defaultValues['number_of_circles'] as int)),
                      //PhraseAppears: defaultValues['PhraseAppears'] ?? '',
                      stampColor: Color(int.tryParse(defaultValues['stamp_color']?.toString() ?? '0xFF000000') ?? 0xFF000000),
                      cardColor: Color(int.tryParse(defaultValues['card_color']?.toString() ?? '0xFF00008B') ?? 0xFF00008B),
                      stampIcon: IconData((defaultValues['stamp_icon'] is num) ? (defaultValues['stamp_icon'] as num).toInt() : 0xE5CA, fontFamily: 'MaterialIcons',),
                      circleColor: Color(int.tryParse(defaultValues['circle_color']?.toString() ?? '0xFFFFFFFF') ?? 0xFFFFFFFF),
                      upperTextColor: Color(int.tryParse(defaultValues['upper_text_color']?.toString() ?? '0xFF000000') ?? 0xFF000000),
                      lowerTextColor: Color(int.tryParse(defaultValues['lower_text_color']?.toString() ?? '0xFF000000') ?? 0xFF000000),
                      upperText: defaultValues['upper_text']?.toString() ?? '',
                      lowerText: defaultValues['lower_text']?.toString() ?? '',
                      exampleText: defaultValues['extra_phrase']?.toString() ?? '',
                      logoCircleSize: (defaultValues['logo_circle_size'] == null || defaultValues['logo_circle_size'] == 0) ? 50 : (defaultValues['logo_circle_size'] as num).toInt(),
                      logoCircleColor: Color(int.tryParse(defaultValues['logo_circle_color']?.toString() ?? '0xFFFFFFFF') ?? 0xFFFFFFFF),
                      nameLayout: defaultValues['name_layout']?.toString() ?? 'Novo Layout', // Adicione esta linha
                    ),
                  ),
                );
              },
              child: const Text('Novo'),
            ),
            const SizedBox(height: 30), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () async {
                // Obtém os layouts do banco de dados
                final layout = await DatabaseLayout().getAllLayouts(); 
                final defaultValues = await DatabaseLayout().getDefaultValues('layout_table');

                // Exibe a lista de layouts em um AlertDialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Selecione um Layout'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: layout.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(layout[index]['name_layout'] ?? 'Sem Nome'),
                              onTap: () {
                                Navigator.pop(context); // Fecha o diálogo

                                /////Um Graaaande print que exibe os detalhes das variáveis retornadas
                                print('Detalhes das variáveis:');
                                layout[index].forEach((key, value) {
                                  // Defina os tipos esperados para cada variável, se necessário
                                  final Map<String, String> tiposEsperados = {
                                    'name_layout': 'String',
                                    'number_of_circles': 'int',
                                    'stamp_color': 'int',
                                    'card_color': 'int',
                                    'stamp_icon': 'int',
                                    'circle_color': 'int',
                                    'upper_text_color': 'int',
                                    'lower_text_color': 'int',
                                    'upper_text': 'String',
                                    'lower_text': 'String',
                                    'extra_phrase': 'String',
                                    'logo_circle_size': 'int',
                                    'logo_circle_color': 'int',
                                  };
                                  final tipoEsperado = tiposEsperados[key] ?? 'Desconhecido';
                                  final tipoArmazenado = value?.runtimeType ?? 'Null';
                                  print('$key: Tipo esperado: $tipoEsperado, Tipo armazenado: $tipoArmazenado, Valor: $value');
                                  print('aehoo');
                                  print('Dados do layout selecionado: ${layout[index]}');
                                });

                                // Aqui você pode adicionar lógica para carregar o layout selecionado
                                print('Layout selecionado: ${layout[index]['name_layout']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LayoutDosCartoes(
                                      stampCount: 1,
                                      numberOfCircles: (layout[index]['number_of_circles'] == null)? 1: int.tryParse(layout[index]['number_of_circles'].toString()) ?? 1,
                                      stampColor: Color(layout[index]['stamp_color']),
                                      cardColor: Color(layout[index]['card_color']),
                                      stampIcon: IconData((defaultValues['stamp_icon'] == null)? 0xE5CA: (defaultValues['stamp_icon'] as num).toInt(),fontFamily: 'MaterialIcons',),
                                      circleColor: Color(layout[index]['circle_color']),
                                      upperTextColor: Color(layout[index]['upper_text_color']),
                                      lowerTextColor: Color(layout[index]['lower_text_color']),
                                      upperText: layout[index]['upper_text'] ?? '',
                                      lowerText: layout[index]['lower_text'] ?? '',
                                      exampleText: layout[index]['extra_phrase'] ?? '',
                                      logoCircleSize: (layout[index]['logo_circle_size'] == null) ? 50 : (layout[index]['logo_circle_size'] as num).toInt(),
                                      logoCircleColor: Color(layout[index]['logo_circle_color']),
                                      nameLayout: layout[index]['name_layout'] ?? 'Novo Layout',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Carregar'),
            ),
          ],
        ),
      ),
    );
  }
}
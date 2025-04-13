import 'package:flutter/material.dart';
import 'package:test/ui/layout_dos_cartoes/labeled_text_input.dart';
import 'package:test/ui/layout_dos_cartoes/slide.dart';
import 'layout_dos_cartoes/number_of_stamps.dart';
import 'layout_dos_cartoes/card.dart';
import 'layout_dos_cartoes/slide_color.dart';
import '../data/database_layout.dart';
import 'package:sqflite/sqflite.dart'; // Para getDatabasesPath
import 'package:path/path.dart'; // Para join

class LayoutDosCartoes extends StatefulWidget {

  int stampCount = 1;
  int numberOfCircles = 1;
  bool PhraseAppears = false;
  Color stampColor = Colors.black;
  Color cardColor = Colors.blue;
  IconData stampIcon = Icons.local_pizza;
  Color circleColor = Colors.white;
  Color upperTextColor = Colors.black;
  Color lowerTextColor = Colors.black;
  String upperText = 'insira sua mensagem aqui Upper';
  String lowerText = 'insira sua mensagem aqui Lower';
  String exampleText = 'Exemplo';
  int logoCircleSize = 10; // Tamanho do círculo da Logo
  Color logoCircleColor = Colors.yellow; // Cor do círculo da Logo
  double colorPosition = 1.0;
  String nameLayout ='Novo Layout';

  LayoutDosCartoes({
    super.key,
    //this.onNameChanged,
    stampCount,
    required this.numberOfCircles,
    //required this.PhraseAppears,
    required this.stampColor,
    required this.cardColor,
    required this.stampIcon,
    required this.circleColor,
    required this.upperTextColor,
    required this.lowerTextColor,
    required this.upperText,
    required this.lowerText,
    required this.exampleText,
    required this.logoCircleSize,
    required this.logoCircleColor,
    required this.nameLayout,
  });

  @override
  _LayoutDosCartoesState createState() => _LayoutDosCartoesState();
}

class _LayoutDosCartoesState extends State<LayoutDosCartoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameLayout.isNotEmpty
            ? widget.nameLayout
            : 'Novo Layout'),
        actions: [
          //TextButton(onPressed: () {}, child: const Text('Save'))
          ElevatedButton(
            onPressed: () async {
              final dbHelper = DatabaseLayout();
              // Obtém o caminho completo do banco de dados e imprime no console
              final dbPath = await getDatabasesPath();
              print('Banco de dados em uso: ${join(dbPath, 'layouts.db')}');
              // Verifica se o layout já existe no banco de dados
              final existingLayout = await dbHelper.getLayoutByName(widget.nameLayout);

              if (existingLayout != null) {
                // Atualiza o layout existente
                await dbHelper.updateLayout(
                  nameLayout: widget.nameLayout,
                  upperText: widget.upperText,
                  lowerText: widget.lowerText,
                  exampleText: widget.exampleText,
                  upperTextColor: widget.upperTextColor.value,
                  lowerTextColor: widget.lowerTextColor.value,
                  cardColor: widget.cardColor.value,
                  logoCircleColor: widget.logoCircleColor.value,
                  circleColor: widget.circleColor.value,
                  stampColor: widget.stampColor.value,
                  stampIcon: widget.stampIcon.codePoint,
                  numberOfCircles: widget.numberOfCircles,
                  logoCircleSize: widget.logoCircleSize,
                );
                print('Layout atualizado com sucesso!');
              } else {
                // Insere um novo layout
                await dbHelper.insertLayout(
                  nameLayout: widget.nameLayout,
                  upperText: widget.upperText,
                  lowerText: widget.lowerText,
                  exampleText: widget.exampleText,
                  upperTextColor: widget.upperTextColor.value,
                  lowerTextColor: widget.lowerTextColor.value,
                  cardColor: widget.cardColor.value,
                  logoCircleColor: widget.logoCircleColor.value,
                  circleColor: widget.circleColor.value,
                  stampColor: widget.stampColor.value,
                  stampIcon: widget.stampIcon.codePoint,
                  numberOfCircles: widget.numberOfCircles,
                  logoCircleSize: widget.logoCircleSize,
                );
                print('Novo layout salvo com sucesso!');
              }
            },
            child: const Text('Save'),
          ),
      
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomCard(
              cardColor: widget.cardColor,
              stampIcon: Icons.local_pizza,
              stampColor: widget.stampColor,
              stampCount: widget.stampCount,
              numberOfCircles: widget.numberOfCircles,
              circleColor:widget.circleColor,
              upperTextColor: widget.upperTextColor,
              lowerTextColor: widget.lowerTextColor,
              upperText: widget.upperText,
              lowerText: widget.lowerText,
              logoCircleSize: widget.logoCircleSize.toDouble(),
              logoCircleColor: widget.logoCircleColor,
            ),

            const Divider(), // Linha divisória

          Expanded(
            child: ListView.builder(
              itemCount: 1, // Número de itens no ListView
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    
                    LabeledTextInput(
                      labelText: 'Nome do Layout:',
                      exampleText:'',
                      onNameChanged: (value) {
                        setState(() {
                          widget.nameLayout = value; // Atualiza o estado com o texto digitado
                        });
                      },
                    ),

                    const SizedBox(height: 10), const Divider(),

                    LabeledTextInput(
                      labelText: 'Mensagem Superior:',
                      exampleText:'',
                      onNameChanged: (value) {
                        setState(() {
                          widget.upperText = value; // Atualiza o estado com o texto digitado
                        });
                      },
                    ),

                    const SizedBox(height: 10), const Divider(),

                    LabeledTextInput(
                      labelText: 'Mensagem Inferior',
                      exampleText:'',
                      onNameChanged: (value) {
                        setState(() {
                          widget.lowerText = value; // Atualiza o estado com o texto digitado
                        });
                      },
                    ),
                    
                    const SizedBox(height: 10), const Divider(),
                    
                    SlideColor(
                      initialColor: widget.stampColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          widget.stampColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Carimbo:',
                      colorPosition: 1,
                    ),

                    const Divider(),

                    SlideColor(
                      initialColor: widget.cardColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          widget.cardColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Cartão:',
                      colorPosition:0.66,
                    ),

                    const Divider(),

                    SlideColor(
                      initialColor: widget.circleColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          widget.circleColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Círculo:',
                    ),
              
                    SlideColor(
                      initialColor: widget.upperTextColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          widget.upperTextColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Texto Superior:',
                      colorPosition:1,
                    ),

                    SlideColor(
                      initialColor: widget.lowerTextColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          widget.lowerTextColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Texto Superior:',
                      colorPosition:1,
                    ),

                    const Divider(), // Linha divisória
                    
                    SlideCircle(
                      onSlideCircleChanged: (newCircleSize) {
                        setState(() {
                          widget.logoCircleSize = newCircleSize.toInt(); // Atualiza o tamanho do circulo no widget pai
                        });
                      },
                      slideText: 'Tamanho do Background da Logo:'
                    ),

                    const Divider(), // Linha divisória

                    SlideColor(
                      initialColor: widget.logoCircleColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          widget.logoCircleColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Círculo da Logo:',
                      colorPosition:0.4,
                    ),


                    NumberOfStamps(
                      numberText: 'Número de Pizzas (Para Exemplo)',
                      stampCount: widget.stampCount,
                      minStamps: 1,
                      maxStamps: widget.numberOfCircles,
                      onStampCountChanged: (newCount) {
                        setState(() {
                          widget.stampCount = newCount; // Atualiza o valor de stampCount
                        });
                      },             
                    ),

                    const Divider(), // Linha divisória abaixo do texto e dropdown

                    NumberOfStamps(
                      numberText: 'Número de Círculos',
                      stampCount: widget.numberOfCircles,
                      minStamps: 1,
                      maxStamps: 18,
                      onStampCountChanged: (newCount) {
                        setState(() {
                          widget.numberOfCircles = newCount; // Atualiza o valor de stampCount
                        // Garante que o número de stamps nunca ultrapasse o número de circles
                            if (widget.stampCount > widget.numberOfCircles) {
                              widget.stampCount = widget.numberOfCircles;
                            }
                        });
                      },             
                    ),

                    const Divider(),
                  ],
                );
              },
            ),
          ),




            
          ],
        ),
      ),
    );
  }
}
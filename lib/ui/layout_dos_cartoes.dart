import 'package:flutter/material.dart';
import 'package:test/ui/layout_dos_cartoes/labeled_text_input.dart';
import 'package:test/ui/layout_dos_cartoes/slide.dart';
import 'layout_dos_cartoes/number_of_stamps.dart';
import 'layout_dos_cartoes/card.dart';
import 'layout_dos_cartoes/slide_color.dart';

class LayoutDosCartoes extends StatefulWidget {
  const LayoutDosCartoes({super.key});

  @override
  _LayoutDosCartoesState createState() => _LayoutDosCartoesState();
}

class _LayoutDosCartoesState extends State<LayoutDosCartoes> {
  int stampCount = 1;
  int numberOfCircles = 1;
  bool newCustomerBonus = false;
  Color stampColor = Colors.black;
  Color cardColor = Colors.blue;
  IconData stampIcon = Icons.local_pizza;
  Color circleColor = Colors.white;
  Color upperTextColor = Colors.black;
  Color lowerTextColor = Colors.black;
  String upperText = 'insira sua mensagem aqui Upper';
  String lowerText = 'insira sua mensagem aqui Lower';
  String exampleText = 'Exemplo';
  double logoCircleSize = 10.0; // Tamanho do círculo da Logo
  Color logoCircleColor = Colors.yellow; // Cor do círculo da Logo


  double colorPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stamp Card'),
        actions: [TextButton(onPressed: () {}, child: const Text('Save'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomCard(
              cardColor: cardColor,
              stampIcon: Icons.local_pizza,
              stampColor: stampColor,
              stampCount: stampCount,
              numberOfCircles: numberOfCircles,
              circleColor:circleColor,
              upperTextColor: upperTextColor,
              lowerTextColor: lowerTextColor,
              upperText: upperText,
              lowerText: lowerText,
              circleSize: logoCircleSize,
              logoCircleColor: logoCircleColor,
            ),

            const Divider(), // Linha divisória

          Expanded(
            child: ListView.builder(
              itemCount: 1, // Número de itens no ListView
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    
                    LabeledTextInput(
                      labelText: 'Mensagem Superior:',
                      exampleText:'',
                      onNameChanged: (value) {
                        setState(() {
                          upperText = value; // Atualiza o estado com o texto digitado
                        });
                      },
                    ),

                    const SizedBox(height: 10), const Divider(),

                    LabeledTextInput(
                      labelText: 'Mensagem Inferior',
                      exampleText:'',
                      onNameChanged: (value) {
                        setState(() {
                          lowerText = value; // Atualiza o estado com o texto digitado
                        });
                      },
                    ),
                    
                    const SizedBox(height: 10), const Divider(),
                    
                    SlideColor(
                      initialColor: stampColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          stampColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Carimbo:',
                      colorPosition: 1,
                    ),

                    const Divider(),

                    SlideColor(
                      initialColor: cardColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          cardColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Cartão:',
                      colorPosition:0.66,
                    ),

                    const Divider(),

                    SlideColor(
                      initialColor: circleColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          circleColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Círculo:',
                    ),
              
                    SlideColor(
                      initialColor: upperTextColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          upperTextColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Texto Superior:',
                      colorPosition:1,
                    ),

                    SlideColor(
                      initialColor: lowerTextColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          lowerTextColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Texto Superior:',
                      colorPosition:1,
                    ),

                    const Divider(), // Linha divisória
                    
                    SlideCircle(
                      onSlideCircleChanged: (newCircleSize) {
                        setState(() {
                          logoCircleSize = newCircleSize; // Atualiza o tamanho do circulo no widget pai
                        });
                      },
                      slideText: 'Tamanho do Background da Logo:'
                    ),

                    const Divider(), // Linha divisória

                    SlideColor(
                      initialColor: logoCircleColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          logoCircleColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Círculo da Logo:',
                      colorPosition:0.4,
                    ),


                    NumberOfStamps(
                      numberText: 'Número de Pizzas (Para Exemplo)',
                      stampCount: stampCount,
                      minStamps: 1,
                      maxStamps: numberOfCircles,
                      onStampCountChanged: (newCount) {
                        setState(() {
                          stampCount = newCount; // Atualiza o valor de stampCount
                        });
                      },             
                    ),

                    const Divider(), // Linha divisória abaixo do texto e dropdown

                    NumberOfStamps(
                      numberText: 'Número de Círculos',
                      stampCount: numberOfCircles,
                      minStamps: 1,
                      maxStamps: 18,
                      onStampCountChanged: (newCount) {
                        setState(() {
                          numberOfCircles = newCount; // Atualiza o valor de stampCount
                        // Garante que o número de stamps nunca ultrapasse o número de circles
                            if (stampCount > numberOfCircles) {
                              stampCount = numberOfCircles;
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
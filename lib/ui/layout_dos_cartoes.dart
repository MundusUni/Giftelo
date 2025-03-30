import 'package:flutter/material.dart';
import 'package:test/ui/layout_dos_cartoes/name_of_layout.dart';
import 'layout_dos_cartoes/number_of_stamps.dart';
import 'layout_dos_cartoes/card.dart';
import 'layout_dos_cartoes/slide_color.dart';

class LayoutDosCartoes extends StatefulWidget {
  const LayoutDosCartoes({super.key});

  @override
  _LayoutDosCartoesState createState() => _LayoutDosCartoesState();
}

class _LayoutDosCartoesState extends State<LayoutDosCartoes> {
  int stampCount = 5;
  bool newCustomerBonus = false;
  Color stampColor = Colors.black;
  IconData stampIcon = Icons.local_pizza;

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
            CustomCard(),
            const Divider(), // Linha divisória



          Expanded(
            child: ListView.builder(
              itemCount: 1, // Número de itens no ListView
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    

                    NameOfLayout(),
                    const SizedBox(height: 20),
                    const Divider(), // Linha divisória
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        spacing: 8,
                        children: List.generate(
                          stampCount,
                          (index) => Icon(stampIcon, color: stampColor, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(), // Linha divisória
                    const SizedBox(height: 20),

                    SlideColor(
                      initialColor: stampColor,
                      onSlideColorChanged: (newColor) {
                        setState(() {
                          stampColor = newColor; // Atualiza a cor no widget pai
                        });
                      },
                      slideText: 'Cor do Carimbo:',
                    ),



                    
              
                    const Divider(), // Linha divisória
                    
                    NumberOfStamps(
                      initialStampCount: stampCount,
                      onStampCountChanged: (newCount) {
                        setState(() {
                          stampCount = newCount; // Atualiza o valor de stampCount
                        });
                      },             
                    ),




                    const Divider(), // Linha divisória abaixo do texto e dropdown
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


// Função para interpolar entre as cores
Color _getInterpolatedColor(double value) {
  // Lista de cores do GradientPainter
  final colors = [
    Colors.black,
    Colors.brown,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.white,
  ];

  // Calcula o índice inicial e final com base no valor do slider
  final index = (value * (colors.length - 1)).floor();
  final nextIndex = (index + 1).clamp(0, colors.length - 1);

  // Calcula a proporção entre as duas cores
  final t = (value * (colors.length - 1)) - index;

  // Interpola entre as duas cores
  return Color.lerp(colors[index], colors[nextIndex], t)!;
}
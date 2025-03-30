import 'package:flutter/material.dart';
import 'card.dart';
import 'stamp.dart';

class CircleAndIconController extends StatefulWidget {
  final Color cardColor;
  final IconData stampIcon;
  final Color stampColor;
  final int stampCount; // Número de ícones
  final int numberOfCircles; // Número de círculos

  const CircleAndIconController({
    super.key,
    required this.cardColor,
    required this.stampIcon,
    required this.stampColor,
    required this.stampCount,
    required this.numberOfCircles,

  });

  @override
  _CircleAndIconControllerState createState() => _CircleAndIconControllerState();
}

class _CircleAndIconControllerState extends State<CircleAndIconController> {
  int stampCount = 1; // Número inicial de ícones
  int numberOfCircles = 1; // Número inicial de círculos

  void _updateNumberOfCircles(int newCount) {
    setState(() {
      numberOfCircles = newCount;
      // Garante que stampCount nunca ultrapasse numberOfCircles
      if (stampCount > numberOfCircles) {
        stampCount = numberOfCircles;
      }
      // Incrementa stampCount automaticamente se um círculo for adicionado
      //if (stampCount < numberOfCircles) {
      //  stampCount = numberOfCircles;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cartão com círculos e ícones
        CustomCard(
          cardColor: widget.cardColor,
          numberOfCircles: numberOfCircles,
          child: Stamp(
            stampCount: stampCount,
            stampIcon: widget.stampIcon,
            stampColor: widget.stampColor,
          ),
        ),
        const SizedBox(height: 20),
        // Controle para o número de círculos
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Número de Círculos:'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (numberOfCircles > 1) {
                      _updateNumberOfCircles(numberOfCircles - 1);
                    }
                    
                  },
                ),
                Text('$numberOfCircles'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (numberOfCircles < 18) {
                      _updateNumberOfCircles(numberOfCircles + 1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Controle para o número de ícones
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Número de Ícones:'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (stampCount > 1) {
                      setState(() {
                        stampCount--;
                      });
                    }
                  },
                ),
                Text('$stampCount'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (stampCount < numberOfCircles) {
                      setState(() {
                        stampCount++;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
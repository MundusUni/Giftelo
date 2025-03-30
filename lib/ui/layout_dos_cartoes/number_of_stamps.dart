import 'package:flutter/material.dart';

class NumberOfStamps extends StatefulWidget {
  final int initialStampCount; // Valor inicial do contador
  final int minStamps; // Número mínimo de carimbos
  final int maxStamps; // Número máximo de carimbos
  final ValueChanged<int> onStampCountChanged; // Callback para enviar o valor atualizado

  const NumberOfStamps({
    super.key,
    this.initialStampCount = 1,
    this.minStamps = 1,
    this.maxStamps = 10,
    required this.onStampCountChanged, // Torna o callback obrigatório
  });

  @override
  _NumberOfStampsState createState() => _NumberOfStampsState();
}

class _NumberOfStampsState extends State<NumberOfStamps> {
  late int stampCount; // Estado interno do contador

  @override
  void initState() {
    super.initState();
    stampCount = widget.initialStampCount; // Inicializa o contador com o valor inicial
  }

  void _increment() {
    if (stampCount < widget.maxStamps) {
      setState(() {
        stampCount++;
        widget.onStampCountChanged(stampCount); // Envia o valor atualizado
      });
    }
  }

  void _decrement() {
    if (stampCount > widget.minStamps) {
      setState(() {
        stampCount--;
        widget.onStampCountChanged(stampCount); // Envia o valor atualizado
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Number of stamps:'),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _decrement, // Chama a função de decremento
            ),
            Text('$stampCount'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _increment, // Chama a função de incremento
            ),
          ],
        ),
      ],
    );
  }
}
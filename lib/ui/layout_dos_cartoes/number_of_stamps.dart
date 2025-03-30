import 'package:flutter/material.dart';

class NumberOfStamps extends StatelessWidget {
  final int stampCount; // Valor do contador vindo de fora
  final int minStamps; // Número mínimo de carimbos
  final int maxStamps; // Número máximo de carimbos
  final ValueChanged<int> onStampCountChanged; // Callback para enviar o valor atualizado
  final String numberText;

  const NumberOfStamps({
    super.key,
    required this.stampCount,
    this.minStamps = 1,
    this.maxStamps = 10,
    required this.onStampCountChanged, // Torna o callback obrigatório
    required this.numberText,
  });

  void _increment() {
    if (stampCount < maxStamps) {
      onStampCountChanged(stampCount + 1); // Notifica o pai com o novo valor
    }
  }

  void _decrement() {
    if (stampCount > minStamps) {
      onStampCountChanged(stampCount - 1); // Notifica o pai com o novo valor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(numberText),
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
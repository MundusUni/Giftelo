import 'package:flutter/material.dart';

class NameOfLayout extends StatelessWidget {
  final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  
  const NameOfLayout({
    super.key,
    this.onNameChanged,
  });

@override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça os widgets horizontalmente
      crossAxisAlignment: CrossAxisAlignment.center, // Alinha verticalmente ao centro
      children: [
        const Text('Nome do Layout:'), // Texto alinhado à esquerda
        const SizedBox(width: 10), // Adiciona 10 pixels de espaço entre o texto e o campo de entrada
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'e.g., Promoção',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Ajusta o padding interno
            ),
            textAlign: TextAlign.right, // Alinha o texto digitado à direita
            onChanged: onNameChanged, // Chama o callback ao alterar o texto
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class Stamp extends StatelessWidget {
  final int stampCount; // Número de ícones
  final IconData stampIcon; // Ícone a ser exibido
  final Color stampColor; // Cor do ícone

  const Stamp({
    super.key,
    required this.stampCount,
    required this.stampIcon,
    required this.stampColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0), // Adiciona 15 pixels de padding na parte superior
      child: Wrap(
        spacing: 15, // Espaçamento entre os ícones
        runSpacing: 10, // Espaçamento entre as linhas,
        alignment: WrapAlignment.start,
        children: List.generate(
          stampCount,
          (index) => Transform.translate(
          offset: const Offset(2, 3), // Move 3 pixels para a direita e 3 pixels para baixo
          child: Icon(
            stampIcon,
            color: stampColor,
            size: 25,
          ),
        ),
        ),
      ),
    );
  }
}
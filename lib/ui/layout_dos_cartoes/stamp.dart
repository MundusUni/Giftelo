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
        spacing: 10, // Espaçamento entre os ícones
        runSpacing: 5, // Espaçamento entre as linhas,
        alignment: WrapAlignment.start,
        children: List.generate(
          stampCount,
          (index) => Icon(stampIcon, color: stampColor, size: 30),
        ),
      ),
    );
  }
}
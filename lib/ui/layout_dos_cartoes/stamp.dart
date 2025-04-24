import 'package:flutter/material.dart';

class Stamp extends StatefulWidget {
  final int stampCount; // Número de ícones
  final IconData stampIcon; // Ícone a ser exibido
  final Color stampColor; // Cor do ícone
  final int iconSize; // Tamanho do círculo

  const Stamp({
    super.key,
    required this.stampCount,
    required this.stampIcon,
    required this.stampColor,
    required this.iconSize,
  });

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0), // Adiciona padding na parte superior
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // Desativa o scroll
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // 6 stamps por linha
          crossAxisSpacing: 10, // Espaçamento horizontal entre os stamps
          mainAxisSpacing: 10, // Espaçamento vertical entre as linhas
        ),
        itemCount: widget.stampCount, // Número total de stamps
        shrinkWrap: true, // Faz o GridView se ajustar ao tamanho do conteúdo
        itemBuilder: (context, index) {
          return Center(
            child: Icon(
              widget.stampIcon, // Ícone do stamp
              color: widget.stampColor, // Cor do stamp
              size: widget.iconSize.toDouble(), // Tamanho do stamp
            ),
          );
        },
      ),
    );
  }
}
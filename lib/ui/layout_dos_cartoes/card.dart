import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  //final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  final cardColor;
  final int numberOfCircles; // Número de círculos a serem exibidos

  const CustomCard({
    super.key,
    //this.onNameChanged,
    required this.cardColor,
    required this.numberOfCircles,
  });

@override 
  Widget build(BuildContext context) {
    // Divide os círculos em duas linhas
    final int circlesPerRow = 6; // Máximo de círculos por linha
    final int topRowCircles = numberOfCircles > circlesPerRow ? circlesPerRow : numberOfCircles;
    final int bottomRowCircles = numberOfCircles > circlesPerRow ? numberOfCircles - circlesPerRow : 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: double.infinity, // Ocupa toda a largura disponível
      height: 150, // Altura do cartão
      color: cardColor, // Azul ou vermelho
      child: Container(
        padding: const EdgeInsets.only(left: 90, right: 15), // Adiciona padding à esquerda e à direita
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Alinha à esquerda
          children: [
            // Primeira linha com três círculos
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Alinha à esquerda
              children: List.generate(
                topRowCircles,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 10), // Espaçamento entre os círculos
                  child: _buildCircle(),
                ),
              ),
            ),
            if (bottomRowCircles > 0) // Exibe a segunda linha apenas se houver círculos
              const SizedBox(height: 10), // Espaçamento entre as linhas
            if (bottomRowCircles > 0)
                        
            // Segunda linha com dois círculos
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Alinha à esquerda
              children: List.generate(
                bottomRowCircles,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 10), // Espaçamento entre os círculos
                  child: _buildCircle(),
                ),
              )
            ),
          ],
        ),
          
          /*child: Text(
            'Cartão',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),*/
      ),
    );
  }

  // Método para criar um círculo branco
  Widget _buildCircle() {
    return Container(
      width: 30, // Largura do círculo
      height: 30, // Altura do círculo
      decoration: const BoxDecoration(
        color: Colors.white, // Cor do círculo
        shape: BoxShape.circle, // Formato circular
      ),
    );
  }
}
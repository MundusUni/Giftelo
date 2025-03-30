import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  //final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  final cardColor;
  final int numberOfCircles; // Número de círculos a serem exibidos
  final Widget? child; // Novo parâmetro para conteúdo adicional dentro do cartão
  

  const CustomCard({
    super.key,
    //this.onNameChanged,
    required this.cardColor,
    required this.numberOfCircles,
    this.child, // Torna o parâmetro opcional
  });

@override 
  Widget build(BuildContext context) {
    // Divide os círculos em duas linhas
    final int circlesPerRow = 6; // Máximo de círculos por linha
    final int topRowCircles = numberOfCircles > circlesPerRow ? circlesPerRow : numberOfCircles;
    final int middleRowCircles = numberOfCircles > 2 * circlesPerRow ? circlesPerRow : (numberOfCircles > circlesPerRow ? numberOfCircles - circlesPerRow : 0);
    final int bottomRowCircles = numberOfCircles > 2 * circlesPerRow ? numberOfCircles - 2 * circlesPerRow : 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: double.infinity,
      height: 180, // Ajuste a altura para acomodar três linhas
      color: cardColor,
      child: Container(
        padding: const EdgeInsets.only(left: 90, right: 15, top:40), // Adiciona padding à esquerda e à direita
        child: Stack(
          children: [
            // Círculos no fundo
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primeira linha de círculos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      topRowCircles,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildCircle(),
                      ),
                    ),
                  ),
                  if (middleRowCircles > 0) const SizedBox(height: 5), // Espaçamento entre as linhas
                  // Segunda linha de círculos
                  if (middleRowCircles > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        middleRowCircles,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _buildCircle(),
                        ),
                      ),
                    ),
                  if (bottomRowCircles > 0) const SizedBox(height: 5), // Espaçamento entre as linhas
                  // Terceira linha de círculos
                  if (bottomRowCircles > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        bottomRowCircles,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _buildCircle(),
                        ),
                      ),
                    ),
                ],
              ),
            // Conteúdo adicional (ícones de pizza)
            if (child != null)
              Align(
                alignment: Alignment.topLeft,
                child: child,
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
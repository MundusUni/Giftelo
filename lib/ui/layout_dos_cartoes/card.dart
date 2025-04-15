import 'package:flutter/material.dart';
import 'stamp.dart';

class CustomCard extends StatefulWidget {
  //final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  final Color cardColor;
  final Color stampColor;
  final IconData stampIcon;
  final IconData stampBackground;
  final int stampCount; // Número de ícones
  final int numberOfCircles; // Número de círculos a serem exibidos
  final Color circleColor;
  final Color upperTextColor;
  final Color lowerTextColor;
  final String upperText;
  final String lowerText;
  final double logoCircleSize;
  final Color logoCircleColor;

  const CustomCard({
    super.key,
    //this.onNameChanged,
    required this.cardColor,
    required this.stampIcon,
    required this.stampBackground,
    required this.stampColor,
    required this.stampCount,
    required this.numberOfCircles,
    required this.circleColor,
    required this.upperTextColor,
    required this.lowerTextColor,
    required this.upperText,
    required this.lowerText,
    required this.logoCircleSize,
    required this.logoCircleColor,
  });

    @override
  _CustomCardState createState() => _CustomCardState();
}

  

class _CustomCardState extends State<CustomCard> {
  late int localStampCount; // Número de stamps gerenciado localmente
  late int localNumberOfCircles; // Número de circles gerenciado localmente

  // Método para criar um círculo branco
  Widget _buildCircle() {
    return Container(
      width: 30, // Largura do círculo
      height: 30, // Altura do círculo
      decoration: BoxDecoration(
        color: widget.circleColor, // Cor do círculo
        shape: BoxShape.circle, // Formato circular
      ),
    );
  }  

  @override 
  Widget build(BuildContext context) {
    // Divide os círculos em duas linhas
    final int circlesPerRow = 6; // Máximo de círculos por linha
    final int topRowCircles = widget.numberOfCircles > circlesPerRow ? circlesPerRow : widget.numberOfCircles;
    final int middleRowCircles = widget.numberOfCircles > 2 * circlesPerRow ? circlesPerRow : (widget.numberOfCircles > circlesPerRow ? widget.numberOfCircles - circlesPerRow : 0);
    final int bottomRowCircles = widget.numberOfCircles > 2 * circlesPerRow ? widget.numberOfCircles - 2 * circlesPerRow : 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: 400,
      height: 180, // Ajuste a altura para acomodar três linhas
      decoration: BoxDecoration(
        color: widget.cardColor, // Cor do Cartão
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.upperText, // 56 Caracteres Texto que será exibido
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.upperTextColor, // Cor do texto superior
                    ),
                    softWrap: false, // Impede que o texto quebre para a próxima linha
                    overflow: TextOverflow.fade, // Permite que o texto continue além dos limites
                  ),
                ),
                // Texto Abaixo dos círculos
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    widget.lowerText, // 56 Caracteres Texto que será exibido
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.lowerTextColor, // Cor do texto inferior
                    ),
                    softWrap: false, // Impede que o texto quebre para a próxima linha
                    overflow: TextOverflow.fade, // Permite que o texto continue além dos limites
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(right:250),
            child: Align (
              alignment: Alignment.center, // Alinha horizontalmente à esquerda e verticalmente ao centro
              child: Container(
                width: widget.logoCircleSize, // Largura do círculo
                height: widget.logoCircleSize, // Altura do círculo
                decoration: BoxDecoration(
                  color: widget.logoCircleColor, // Cor do círculo
                  shape: BoxShape.circle, // Formato circular
                ),
              ),
            ),
          ),

          Container(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(left: 102, right: 3, top:40), // Adiciona padding à esquerda e à direita
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
                            child: Icon(
                              widget.stampBackground, // Ícone vindo da variável
                              size: 30, // Tamanho do ícone
                              color: widget.circleColor, // Cor do ícone (ou outra cor desejada)
                            ),
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
                            child: Icon(
                              widget.stampBackground, // Ícone vindo da variável
                              size: 30, // Tamanho do ícone
                              color: widget.circleColor, // Cor do ícone (ou outra cor desejada)
                            ),
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
                            child: Icon(
                              widget.stampBackground, // Ícone vindo da variável
                              size: 30, // Tamanho do ícone
                              color: widget.circleColor, // Cor do ícone (ou outra cor desejada)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Ícones de pizza sobrepostos aos círculos
                Align(
                  alignment: Alignment.topLeft,
                  child: Stamp(
                    stampCount: widget.stampCount,
                    stampIcon: widget.stampIcon,
                    stampColor: widget.stampColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'stamp.dart';
import 'dart:io';

class CustomCard extends StatefulWidget {
  //final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  final Color cardColor;
  final Color stampColor;
  final dynamic stampIcon;
  final dynamic stampBackground;
  final int stampCount; // Número de ícones
  final int numberOfCircles; // Número de círculos a serem exibidos
  final Color circleColor;
  final Color upperTextColor;
  final Color lowerTextColor;
  final String upperText;
  final String lowerText;
  final double logoCircleSize;
  final int circleSize;
  final int iconSize;
  final Color logoCircleColor;
  final File? logo;
  final double logoSize;


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
    required this.circleSize,
    required this.iconSize,
    this.logo,
    required this.logoSize,
  });

    @override
  _CustomCardState createState() => _CustomCardState();
}

  

class _CustomCardState extends State<CustomCard> {
  double width = 400;
  double height = 180;

  // Método helper para renderizar ícone ou imagem
  Widget _buildIconOrImage(dynamic iconData, Color color, double size) {
    if (iconData is IconData) {
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    } else if (iconData is String) {
      return Image.asset(
        iconData,
        width: size,
        height: size,
        fit: BoxFit.contain,
        color: color,
        colorBlendMode: BlendMode.srcIn,
      );
    }
    return Container(); // Fallback
  }

  @override 
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: width,
      height: height, // Ajuste a altura para acomodar três linhas
      decoration: BoxDecoration(
        color: widget.cardColor, // Cor do Cartão
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          

          // Círculo branco à esquerda
          Align(
            alignment: Alignment(-0.7, 0.0),
            child: Transform.translate(
              offset: Offset(-widget.logoCircleSize / 2, 0), // Só compensa no eixo X
              child: Container(
                width: widget.logoCircleSize,
                height: widget.logoCircleSize,
                decoration: BoxDecoration(
                  color: widget.logoCircleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),


          //Logo
          if (widget.logo != null)
          Align(
            alignment: Alignment(-0.7, 0.0),
            child: Transform.translate(
              offset: Offset(-widget.logoSize / 2, 0), // Compensa somente no eixo X
              child: Image.file(
                widget.logo!,
                height: widget.logoSize,
                width: widget.logoSize,
                fit: BoxFit.cover,
              ),
            ),
          ),


          //Container que contem o GridView
          Align(
            alignment: Alignment(0.75,0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.29,
              decoration: BoxDecoration(
                color: widget.cardColor, // Cor do cartão
              ),
              child: Stack(
                children: [
                  
                  // GridView para os círculos
                  GridView.builder(
                    padding: EdgeInsets.zero, // remove o espaço interno
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                      mainAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                    ),
                    itemCount: widget.numberOfCircles,
                    itemBuilder: (context, index) {
                      bool showStamp = index < widget.stampCount;
                      
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final cellWidth = constraints.maxWidth;
                          final cellHeight = constraints.maxHeight;
                          
                          return SizedBox(
                            width: cellWidth,
                            height: cellHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                // Círculo de fundo absolutamente centralizado
                                Positioned(
                                  left: cellWidth / 2 - widget.circleSize / 2,
                                  top: cellHeight / 2 - widget.circleSize / 2,
                                  width: widget.circleSize.toDouble(),
                                  height: widget.circleSize.toDouble(),
                                  child: _buildIconOrImage(
                                    widget.stampBackground,
                                    widget.circleColor,
                                    widget.circleSize.toDouble(),
                                  ),
                                ),
                                
                                // Carimbo absolutamente centralizado
                                if (showStamp)
                                  Positioned(
                                    left: cellWidth / 2 - widget.iconSize / 2,
                                    top: cellHeight / 2 - widget.iconSize / 2,
                                    width: widget.iconSize.toDouble(),
                                    height: widget.iconSize.toDouble(),
                                    child: _buildIconOrImage(
                                      widget.stampIcon,
                                      widget.stampColor,
                                      widget.iconSize.toDouble(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),


          // Texto Acima dos círculos
          Container(
            width: double.infinity,
            alignment: Alignment(0,-0.92),
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
            alignment: Alignment(0,0.92),
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
    );
  }
}
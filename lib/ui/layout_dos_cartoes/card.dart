import 'package:flutter/material.dart';
import 'stamp.dart';

class CustomCard extends StatefulWidget {
  //final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  final Color cardColor;
  final Color stampColor;
  final IconData stampIcon;
  final int stampCount; // Número de ícones
  final int numberOfCircles; // Número de círculos a serem exibidos

  const CustomCard({
    super.key,
    //this.onNameChanged,
    required this.cardColor,
    required this.stampIcon,
    required this.stampColor,
    required this.stampCount,
    required this.numberOfCircles,
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
      decoration: const BoxDecoration(
        color: Colors.white, // Cor do círculo
        shape: BoxShape.circle, // Formato circular
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    // Inicializa os valores locais com os valores do widget pai
    localStampCount = widget.stampCount;
    localNumberOfCircles = widget.numberOfCircles;
  }

  void _updateNumberOfCircles(int newCount) {
    setState(() {
      localNumberOfCircles = newCount;

      // Garante que o número de stamps nunca ultrapasse o número de circles
      if (localStampCount > localNumberOfCircles) {
        localStampCount = localNumberOfCircles;
      }
    });
  }

  void _updateStampCount(int newCount) {
    setState(() {
      // Atualiza o número de stamps, mas garante que ele nunca ultrapasse o número de circles
      if (newCount <= localNumberOfCircles) {
        localStampCount = newCount;
      }
    });
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
      width: double.infinity,
      height: 180, // Ajuste a altura para acomodar três linhas
      color: widget.cardColor,
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
        
          /*child: Text(
            'Cartão',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),*/
      ),
    );
  }
}
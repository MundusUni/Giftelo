import 'package:flutter/material.dart';

class SlideCircle extends StatefulWidget {
  final ValueChanged<double> onSlideCircleChanged; // Callback para enviar a cor atualizada
  final String slideText; // Texto do slider
  final double circleSize; // Posição do slider

  const SlideCircle({
    super.key,
    required this.onSlideCircleChanged,
    required this.slideText,
    this.circleSize = 0,
  });

  @override
  _SlideCircleState createState() => _SlideCircleState();
}

class _SlideCircleState extends State<SlideCircle> {
  late double circleSize; // Posição do slider

  @override
  void initState() {
    super.initState();
    circleSize = widget.circleSize; // Valor inicial do slider
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.slideText), // Texto do slider
        Stack(
          alignment: Alignment.center,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.grey.shade700, // Cor dinâmica da trilha ativa
                inactiveTrackColor: Colors.grey.shade300, // Cor da trilha inativa
                thumbColor: Colors.grey.shade700, // Cor do botão do slider
                overlayColor: Colors.black.withAlpha(50), // Cor do overlay ao pressionar
              ),
              child: Slider(
                value: circleSize, // Valor dinâmico do slider
                min: 0.0,
                max: 70.0,
                onChanged: (value) {
                  setState(() {
                    circleSize = value; // Atualiza a posição do slider
                  });
                  widget.onSlideCircleChanged(value); // Envia a cor atualizada para o pai
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
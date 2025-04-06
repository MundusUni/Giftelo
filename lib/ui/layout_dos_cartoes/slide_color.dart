import 'package:flutter/material.dart';

class SlideColor extends StatefulWidget {
  final Color initialColor; // Cor inicial
  final ValueChanged<Color> onSlideColorChanged; // Callback para enviar a cor atualizada
  final String slideText; // Texto do slider
  final double colorPosition; // Posição do slider

  const SlideColor({
    super.key,
    required this.initialColor,
    required this.onSlideColorChanged,
    required this.slideText,
    this.colorPosition = 0,

  });

  @override
  _SlideColorState createState() => _SlideColorState();
}

class _SlideColorState extends State<SlideColor> {
  late double colorPosition; // Posição do slider
  late Color slideColor; // Cor atual do slider

  @override
  void initState() {
    super.initState();
    colorPosition = widget.colorPosition; // Valor inicial do slider
    slideColor = widget.initialColor; // Define a cor inicial
  }

  Color _getInterpolatedColor(double value) {
    final colors = [
      Colors.white,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
      Colors.brown,
      Colors.black,
    ];

    // Calcula o índice inicial e final com base no valor do slider
    final index = (value * (colors.length - 1)).floor();
    final nextIndex = (index + 1).clamp(0, colors.length - 1);

    // Calcula a proporção entre as duas cores
    final t = (value * (colors.length - 1)) - index;

    // Interpola entre as duas cores
    return Color.lerp(colors[index], colors[nextIndex], t)!;
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
                activeTrackColor: slideColor, // Cor dinâmica da trilha ativa
                inactiveTrackColor: Colors.grey.shade300, // Cor da trilha inativa
                thumbColor: slideColor, // Cor do botão do slider
                overlayColor: slideColor.withAlpha(50), // Cor do overlay ao pressionar
              ),
              child: Slider(
                value: colorPosition, // Valor dinâmico do slider
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    colorPosition = value; // Atualiza a posição do slider
                    slideColor = _getInterpolatedColor(value); // Atualiza a cor
                  });
                  widget.onSlideColorChanged(slideColor); // Envia a cor atualizada para o pai
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para usar LengthLimitingTextInputFormatter

class LabeledTextInput extends StatefulWidget {
  final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado
  final String labelText; // Texto do rótulo
  final String exampleText; // Texto de exemplo
  
  const LabeledTextInput({
    super.key,
    this.onNameChanged,
    required this.labelText,
    required this.exampleText,
  });

  @override
  _LabeledTextInputState createState() => _LabeledTextInputState();
}

class _LabeledTextInputState extends State<LabeledTextInput> {
  String _currentText = ''; // Armazena o texto digitado localmente

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça os widgets horizontalmente
      crossAxisAlignment: CrossAxisAlignment.center, // Alinha verticalmente ao centro
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(fontSize: 16),
          ), // Texto alinhado à esquerda
        const SizedBox(width: 10), // Adiciona 10 pixels de espaço entre o texto e o campo de entrada
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: widget.exampleText,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Ajusta o padding interno
            ),
            textAlign: TextAlign.right, // Alinha o texto digitado à direita
            onChanged: (value) {
              setState(() {
                _currentText = value; // Atualiza o texto localmente
              });
              if (widget.onNameChanged != null) {
                widget.onNameChanged!(value); // Envia o texto para o callback
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(56), // Limita o número de caracteres a 56
            ],
          ),
        ),
      ],
    );
  }
}
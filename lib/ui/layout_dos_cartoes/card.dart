import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final ValueChanged<String>? onNameChanged; // Callback opcional para capturar o valor digitado

  const CustomCard({
    super.key,
    this.onNameChanged,
  });

@override 
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: double.infinity, // Ocupa toda a largura disponível
      height: 150, // Altura do cartão
      color: Colors.red, // Azul ou vermelho
      child: const Center(
        child: Text(
          'Cartão',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class LayoutDosCartoes extends StatefulWidget {
  const LayoutDosCartoes({super.key});

  @override
  _LayoutDosCartoesState createState() => _LayoutDosCartoesState();
}

class _LayoutDosCartoesState extends State<LayoutDosCartoes> {
  int selectedOption = 1; // Valor inicial (1 = azul)
  final List<int> items = [1]; // Inicialmente, apenas um item na lista

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Layout dos Cartões")),
      body: ListView.builder(
        itemCount: items.length, // Número de itens na lista (inicialmente 1)
        itemBuilder: (context, index) {
          return Column(
            children: [
              // Retângulo (Cartão de Visitas)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                width: double.infinity, // Ocupa toda a largura disponível
                height: 150, // Altura do cartão
                color: selectedOption == 1 ? Colors.blue : Colors.red, // Azul ou vermelho
                child: Center(
                  child: Text(
                    'Cartão ${items[index]}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              // Dropdown para selecionar a cor
              DropdownButton<int>(
                value: selectedOption,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text("1 - Azul"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("2 - Vermelho"),
                  ),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    selectedOption = newValue ?? 1; // Atualiza a opção selecionada
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
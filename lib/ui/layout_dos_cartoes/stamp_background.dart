import 'package:flutter/material.dart';

class StampBackgroundSelector extends StatefulWidget {
  final IconData stampBackground; // Variável para armazenar o formato atual
  final Color circleColor; // Cor do círculo
  final ValueChanged<IconData> onShapeChanged; // Callback para passar o valor para o widget pai


  const StampBackgroundSelector({
    super.key,
    this.stampBackground = const IconData(0xe163, fontFamily: 'MaterialIcons'), // Valor padrão
    this.circleColor = Colors.white, // Cor padrão
    required this.onShapeChanged,
  });

  @override
  State<StampBackgroundSelector> createState() => _StampBackgroundSelectorState();
}

class _StampBackgroundSelectorState extends State<StampBackgroundSelector> {
  late IconData currentIcon;

  @override
  void initState() {
    super.initState();
    currentIcon = IconData(0xe163, fontFamily: 'MaterialIcons'); // Ícone padrão (Círculo)
  }

  // Método para exibir o ícone correspondente
  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      color: Colors.black, // Cor definida pelo widget pai
      size: 30, // Tamanho do ícone
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft, // Alinha o texto à esquerda
              child: const Text('Selecione o Ícone:'),
            ),
          ),
          Align(),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight, // Alinha o ícone ao centro
              child: _buildIcon(currentIcon), // Exibe o ícone atual
            ),
          ),
        ],
      ),
          
          
      onTap: () async {
        // Exibe o Popup e aguarda a escolha do usuário
        final selectedIcon = await showDialog<IconData>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Selecione o Ícone'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _popupOption(IconData(0xe163, fontFamily: 'MaterialIcons'), 'Círculo'),
                _popupOption(IconData(0xf0570, fontFamily: 'MaterialIcons'), 'Quadrado'),
                _popupOption(IconData(0xf0385, fontFamily: 'MaterialIcons'), 'Quadrado Arredondado'),
                _popupOption(IconData(0xf0546, fontFamily: 'MaterialIcons'), 'Pentágono'),
                _popupOption(IconData(0xf0517, fontFamily: 'MaterialIcons'), 'Hexágono'),
                _popupOption(IconData(0xe25b, fontFamily: 'MaterialIcons'), 'Coração'),
                _popupOption(IconData(0xe596, fontFamily: 'MaterialIcons'), 'Escudo'),
                _popupOption(IconData(0xe2a3, fontFamily: 'MaterialIcons'), 'Pasta'),
                _popupOption(IconData(0xe6f2, fontFamily: 'MaterialIcons'), 'Maleta'),
                _popupOption(IconData(0xe154, fontFamily: 'MaterialIcons'), 'Chat'),
                _popupOption(IconData(0xe16f, fontFamily: 'MaterialIcons'), 'Nuvem'),
                _popupOption(IconData(0xe0f1, fontFamily: 'MaterialIcons'), 'Marcador'),
                _popupOption(IconData(0xe5f9, fontFamily: 'MaterialIcons'), 'Estrela'),

                
              ],
            ),
          ),
        );

        // Atualiza o ícone selecionado
        if (selectedIcon != null) {
          setState(() {
            currentIcon = selectedIcon;
          });
          widget.onShapeChanged(selectedIcon); // Notifica o widget pai
        }
      },
    );
  }

  // Método para criar uma opção no popup
  Widget _popupOption(IconData icon, String label) {
    return ListTile(
      leading: _buildIcon(icon), // Ícone que representa a opção
      title: Text(label),
      onTap: () {
        Navigator.pop(context, icon); // Retorna o ícone selecionado
      },
    );
  }
}
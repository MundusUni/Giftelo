import 'package:flutter/material.dart';

class StampIconSelector extends StatefulWidget {
  final IconData stampIcon; // Ícone padrão
  final ValueChanged<IconData> onIconChanged; // Callback para enviar o ícone selecionado ao widget pai

  const StampIconSelector({
    super.key,
    this.stampIcon = Icons.local_pizza, // Ícone padrão: pizza
    required this.onIconChanged,
  });

  @override
  State<StampIconSelector> createState() => _StampIconSelectorState();
}

class _StampIconSelectorState extends State<StampIconSelector> {
  late IconData currentIcon;

  @override
  void initState() {
    super.initState();
    currentIcon = widget.stampIcon; // Inicializa com o ícone padrão
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Carimbo:'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(currentIcon, size: 24), // Mostra o ícone atual
          const Icon(Icons.arrow_forward_ios, size: 16), // Seta indicativa
        ],
      ),
      onTap: () async {
        // Exibe o Popup e aguarda a escolha do usuário
        final selectedIcon = await showDialog<IconData>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Selecione o Carimbo'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildIconOptions(),
              ),
            ),
          ),
        );

        if (selectedIcon != null && selectedIcon != currentIcon) {
          setState(() {
            currentIcon = selectedIcon; // Atualiza o ícone selecionado
          });
          widget.onIconChanged(selectedIcon); // Envia o callback para o widget pai
        }
      },
    );
  }

  // Cria a lista de opções de ícones
  List<Widget> _buildIconOptions() {
    const icons = [
      Icons.local_pizza,
      Icons.star,
      Icons.favorite,
      Icons.cake,
      Icons.school,
      Icons.flight,
      Icons.sports_soccer,
      Icons.music_note,
      Icons.home,
      Icons.work,
    ];

    return icons
        .map(
          (icon) => ListTile(
            leading: Icon(icon, size: 24), // Mostra o ícone
            title: Text(icon.codePoint.toRadixString(16)), // Nome ou código do ícone
            onTap: () => Navigator.of(context).pop(icon), // Retorna o ícone selecionado
          ),
        )
        .toList();
  }
}
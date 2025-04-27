import 'package:flutter/material.dart';

class StampBackgroundSelector extends StatefulWidget {
  final List<Map<String, dynamic>> iconOptions; // Lista de ícones e rótulos
  final IconData stampBackground; // Variável para armazenar o formato atual
  final Color circleColor; // Cor do círculo
  final ValueChanged<IconData> onShapeChanged; // Callback para passar o valor para o widget pai
  final String text; // Texto a ser exibido no widget


  const StampBackgroundSelector({
    super.key,
    required this.iconOptions, // Lista de opções passada pelo widget pai
    this.stampBackground = const IconData(0xe163, fontFamily: 'MaterialIcons'), // Valor padrão
    this.circleColor = Colors.white, // Cor padrão
    this.text = 'Selecione o Ícone:',
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
    currentIcon = widget.stampBackground; // Ícone padrão (Círculo)
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
      contentPadding: EdgeInsets.zero, // Remove o padding padrão
      title: Row(
        children: [
          Flexible(
            child: Align(
              alignment: Alignment.centerLeft, // Alinha o texto à esquerda
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 14, // Define o tamanho da fonte
                  fontWeight: FontWeight.normal, // Define o peso da fonte (opcional)
                  color: Colors.black, // Define a cor do texto (opcional)
                ),
                overflow: TextOverflow.visible, // Adiciona "..." se o texto for muito longo
                maxLines: 1, // Garante que o texto fique em uma única linha
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight, // Alinha o ícone à direita
            child: _buildIcon(currentIcon), // Exibe o ícone atual
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
                // Conteúdo rolável
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.iconOptions.map((option) {
                        return _popupOption(
                          option['icon'] as IconData, // Ícone
                          option['label'] as String, // Rótulo
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Indicador visual no final
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.arrow_downward, // Ícone de seta para cima
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
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
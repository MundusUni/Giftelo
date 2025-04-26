import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LogoUploader extends StatefulWidget {
  final Function(File?) onLogoSelected; // Callback para enviar o logo para o widget pai

  const LogoUploader({
    super.key, // Adiciona a chave diretamente no construtor
    required this.onLogoSelected, // Define o callback como obrigatório
  });

  @override
  _LogoUploaderState createState() => _LogoUploaderState();
}

class _LogoUploaderState extends State<LogoUploader> {
  File? logo; // Variável para armazenar a imagem carregada

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        logo = File(pickedFile.path); // Armazena a imagem na variável 'logo'

        // Envia a imagem selecionada para o widget pai via callback
        widget.onLogoSelected(logo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Logo',
          style: TextStyle(fontSize: 16),
        ),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Carregar'),
        ),
      ],
    );
  }
}

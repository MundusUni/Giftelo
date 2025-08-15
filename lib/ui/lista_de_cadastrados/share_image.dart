import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareImageToWhatsApp(Uint8List imageBytes) async {
    try {
      // Cria um arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.png');
      
      // Escreve a imagem no arquivo temporário
      await tempFile.writeAsBytes(imageBytes);
      
      // Compartilha o arquivo com o WhatsApp ou qualquer outro app
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: 'Este é o seu cartão de fidelidade digital. A cada visita, ele te aproxima de um presente nosso. É a nossa forma de agradecer pela preferência e parceria!',
      );
    } catch (e) {
      debugPrint('Erro ao compartilhar: $e');
    }
  }
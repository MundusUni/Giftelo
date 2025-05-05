import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../layout_dos_cartoes/card.dart'; // Importar o widget do cartão
import '/data/database_users.dart';
import '/data/database_layout.dart';

Future<Uint8List?> generateCardImage(BuildContext context, int id) async {

  final GlobalKey repaintKey = GlobalKey();

  // Buscando todos os usuários, ou seja, buscando todos os dados para o id específico
  final dbUser = DatabaseUser();
  final users = await dbUser.getAllUsers();

  // Encontrando o usuário pelo id
  final user = users.firstWhere((user) => user['id'] == id);

  // Pegar o valor de 'layout' do usuário
  String layoutName = user['layout'];

   // Buscar os dados do layout no banco de layouts
  final dbLayout = DatabaseLayout();
  final layoutData = await dbLayout.getLayoutByName(layoutName);

    final widget = Material(
      color: Colors.transparent,
      child: Center(
        child: Offstage(
          offstage: true, // Não queremos que o widget apareça na tela
          child: RepaintBoundary(
            key: repaintKey,
            child: CustomCard(
              // aqui você passa suas variáveis
              cardColor: Color(layoutData?['card_color'] ?? 0xFFFFFFFF),
              stampIcon: layoutData?['stamp_icon'] != null ? IconData(layoutData!['stamp_icon'], fontFamily: 'MaterialIcons') : const IconData(0xe163, fontFamily: 'MaterialIcons'),
              stampBackground: layoutData?['stamp_background'] != null ? IconData(layoutData!['stamp_background'], fontFamily: 'MaterialIcons') : const IconData(0xe163, fontFamily: 'MaterialIcons'),
              stampColor: Color(layoutData?['stamp_color'] ?? 0xFF000000),
              stampCount: user['usos'],
              numberOfCircles: layoutData?['number_of_circles'],
              circleColor: Color(layoutData?['circle_color'] ?? 0xFF888888),
              upperTextColor: Color(layoutData?['upper_text_color'] ?? 0xFF000000),
              lowerTextColor: Color(layoutData?['lower_text_color'] ?? 0xFF000000),
              upperText: layoutData?['upper_text'],
              lowerText: layoutData?['lower_text'],
              logoCircleSize: (layoutData?['logo_circle_size'] as num?)?.toDouble() ?? 40.0,
              logoCircleColor: Color(layoutData?['logo_circle_color'] ?? 0x00000000),
              iconSize: layoutData?['icon_size'],
              circleSize: layoutData?['circle_size'],
              logo: layoutData?['logo'],
              logoSize: (layoutData?['logo_size'] as num?)?.toDouble() ?? 30.0,
            ),
          ),
        ),
      ),
    );

  // Adicionar temporariamente na árvore
  final overlay = Overlay.of(context, rootOverlay: true);
  OverlayEntry entry = OverlayEntry(builder: (context) => widget);
  overlay.insert(entry);

  await Future.delayed(const Duration(milliseconds: 100)); // dá tempo para desenhar

  try {
    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 3.0); // qualidade da imagem
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  } finally {
    entry.remove();
  }
}

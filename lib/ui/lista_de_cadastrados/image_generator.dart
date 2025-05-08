import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import '../layout_dos_cartoes/card.dart';
import '/data/database_users.dart';
import '/data/database_layout.dart';

Future<Uint8List?> generateCardImage(BuildContext context, int id) async {
  final GlobalKey repaintKey = GlobalKey();

  // Buscando dados do usuário e do layout
  final dbUser = DatabaseUser();
  final users = await dbUser.getAllUsers();
  final user = users.firstWhere((user) => user['id'] == id);
  String layoutName = user['layout'];

  final dbLayout = DatabaseLayout();
  final layoutData = await dbLayout.getLayoutByName(layoutName);

  // Criando o widget invisível
  final widget = Positioned(
    left: -1000, // fora da tela
    top: -1000,
    child: Material(
      type: MaterialType.transparency,
      child: RepaintBoundary(
        key: repaintKey,
        child: CustomCard(
          cardColor: Color(layoutData?['card_color'] ?? 0xFFFFFFFF),
          stampIcon: layoutData?['stamp_icon'] != null
              ? IconData(layoutData!['stamp_icon'], fontFamily: 'MaterialIcons')
              : const IconData(0xe163, fontFamily: 'MaterialIcons'),
          stampBackground: layoutData?['stamp_background'] != null
              ? IconData(layoutData!['stamp_background'], fontFamily: 'MaterialIcons')
              : const IconData(0xe163, fontFamily: 'MaterialIcons'),
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
  );



  // Inserindo o widget oculto na árvore
  final overlay = Overlay.of(context, rootOverlay: true);
  final entry = OverlayEntry(
    builder: (_) => Stack(
      children: [widget],
    ),
  );
  overlay.insert(entry);

  try {
    // Aguarda o frame atual terminar
    await Future.delayed(Duration.zero);
    await SchedulerBinding.instance.endOfFrame;

    // Agora começa a checar se o widget foi pintado
    await _waitForPaint(() {
      final context = repaintKey.currentContext;
      final renderObject = context?.findRenderObject();
      return renderObject is RenderRepaintBoundary && !renderObject.debugNeedsPaint;
    });

    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();

  } finally {
    entry.remove();
  }
}

// Espera até que a função isReady() retorne true em um frame pronto
Future<void> _waitForPaint(bool Function() isReady) async {
  while (!isReady()) {
    final completer = Completer<void>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    await completer.future;
  }
}

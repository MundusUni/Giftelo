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

  // Definir dimensões fixas para o cartão - IMPORTANTE manter estas dimensões exatas
  const double cardWidth = 380.0;
  const double cardHeight = 200.0;

  // Criando o widget temporário fora da tela
  final overlayWidget = Positioned(
    left: -2000, // Bem fora da tela para garantir
    top: -2000,
    child: SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: RepaintBoundary(
        key: repaintKey,
        child: Material(
          color: Colors.transparent,
          child: MediaQuery(
            data: MediaQueryData.fromView(WidgetsBinding.instance.window),
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
      ),
    ),
  );

  // Inserindo o widget oculto na árvore
  final overlay = Overlay.of(context, rootOverlay: true);
  final entry = OverlayEntry(builder: (_) => overlayWidget);
  overlay.insert(entry);

  try {
    // Aguarda o próximo frame para garantir que o widget seja renderizado
    await Future.delayed(Duration.zero);
    await SchedulerBinding.instance.endOfFrame;
    
    // Aguarda até que o widget seja pintado corretamente
    await _waitForPaint(() {
      final renderObject = repaintKey.currentContext?.findRenderObject();
      return renderObject is RenderRepaintBoundary && 
             !renderObject.debugNeedsPaint && 
             renderObject.hasSize &&
             renderObject.size.width == cardWidth &&
             renderObject.size.height == cardHeight;
    });

    // Captura a imagem do widget
    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    // Use um pixelRatio fixo para garantir qualidade consistente independente do dispositivo
    const double pixelRatio = 2.0; // Aumenta a resolução da imagem exportada
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData?.buffer.asUint8List();
  } catch (e) {
    print('Erro ao gerar imagem: $e');
    return null;
  } finally {
    // Sempre remove o entry para não poluir a árvore de widgets
    entry.remove();
  }
}

// Aguarda até que a condição de pintura seja atendida
Future<void> _waitForPaint(bool Function() isReady) async {
  int attempts = 0;
  const maxAttempts = 20; // Aumentado para dar mais tempo
  
  while (!isReady() && attempts < maxAttempts) {
    attempts++;
    final completer = Completer<void>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    await completer.future;
    // Pequeno delay adicional para garantir tempo de renderização
    await Future.delayed(const Duration(milliseconds: 16)); // ~1 frame a 60fps
  }
  
  if (attempts >= maxAttempts) {
    print('Aviso: Tempo máximo excedido aguardando a renderização');
  }
}

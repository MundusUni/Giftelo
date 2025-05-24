import 'package:flutter/material.dart';
import 'package:test/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase/firebase_options.dart';




Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Garante que o Firebase seja inicializado antes de qualquer widget ser carregado
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Inicializa o Firebase com as configurações da plataforma atual
  );
  runApp(const GifteloApp());
}

class GifteloApp extends StatelessWidget {
  const GifteloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true, // Mantém Material 3 ativado
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
      home: LoginPage(),
    );
  }
}


//flutter clean
//flutter pub get
//flutter build apk --debug
//flutter run --no-enable-impeller

import 'package:flutter/material.dart';
import 'package:test/ui/home_screen.dart';
import 'package:test/ui/login_screen.dart';

void main() {
  runApp(const BarbeiroApp());
}

class BarbeiroApp extends StatelessWidget {
  const BarbeiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true, // Mantém Material 3 ativado
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          //backgroundColor: Colors.black, // Define a cor de fundo da BottomNavigationBar
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

//flutter clean
//flutter pub get
//flutter build apk --debug
//flutter run --no-enable-impeller

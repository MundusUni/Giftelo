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
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
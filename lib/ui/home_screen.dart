import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super (key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> body = [
    Icon(Icons.menu),
    Icon(Icons.question_mark),
    Icon(Icons.add),
    Icon(Icons.settings),
    Icon(Icons.badge),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed, // Importante para mostrar a cor de fundo
  backgroundColor: Colors.black54,
  currentIndex: _currentIndex,
  onTap: (int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  },
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.black,
  items: const [
        BottomNavigationBarItem(
          label: 'Lista',
          icon: Icon(Icons.menu),
        ),
        BottomNavigationBarItem(
          label: 'Tutorial',
          icon: Icon(Icons.question_mark),
        ),
        BottomNavigationBarItem(
          label: 'Adicionar',
          icon: Icon(Icons.add),
        ),
        BottomNavigationBarItem(
          label: 'Layouts',
          icon: Icon(Icons.badge),
        ),
        BottomNavigationBarItem(
          label: 'Configurações',
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
}
}

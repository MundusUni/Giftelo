import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey,
        selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.menu), 
          label: 'Lista de Cadastrados',
          ),
        NavigationDestination(
          icon: Icon(Icons.question_mark), 
          label: 'Tutorial',
          ),
        NavigationDestination(
          icon: Icon(Icons.add), 
          label: 'Adicionar Novo',
          ),
        NavigationDestination(
          icon: Icon(Icons.badge), 
          label: 'Layouts',
          ),
        NavigationDestination(
          icon: Icon(Icons.settings), 
          label: 'Configurações',
          ),
        ]
      );
  }
}
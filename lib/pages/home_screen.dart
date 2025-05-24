import 'package:flutter/material.dart';
import 'lista_de_cadastrados.dart';
import 'layout_start.dart';
import 'config.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super (key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

@override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5BB51),
            appBar: AppBar(
              backgroundColor: const Color(0xFF00284F),
              bottom: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Color(0xFFF5BB51),
                indicatorColor: Color(0xFFF5BB51), // Cor da linha de seleção
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.menu), text: 'Lista'),
                  Tab(icon: Icon(Icons.badge), text: 'Layouts'),
                  Tab(icon: Icon(Icons.settings), text: 'Configurações'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: const [
                ListaDeCadastrados(),
                LayoutStart(),
                Config(),
              ],
            ),
    );
  }


  /*
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
*/
}

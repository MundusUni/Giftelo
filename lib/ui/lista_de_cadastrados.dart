import 'package:flutter/material.dart';
import 'database_helper.dart';

class ListaDeCadastrados extends StatefulWidget {
  const ListaDeCadastrados({Key? key}) : super(key: key);

  @override
  _ListaDeCadastradosState createState() => _ListaDeCadastradosState();
}

class _ListaDeCadastradosState extends State<ListaDeCadastrados> {
  List<Map<String, dynamic>> users = [];
  final _dbHelper = DatabaseHelper();

  final _nomeController = TextEditingController();
  final _celularController = TextEditingController();
  final _layoutController = TextEditingController();
  final _maxUsosController = TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Carregar usuários do banco ao abrir a tela
  }

  Future<void> _loadUsers() async {
    final data = await _dbHelper.getAllUsers();
    setState(() {
      users = data;
    });
  }

  Future<void> _adicionarCliente() async {
    if (_nomeController.text.isEmpty) return;

    await _dbHelper.addUser(
      _nomeController.text,
      _celularController.text,
      _layoutController.text,
      int.parse(_maxUsosController.text),
    );

    _nomeController.clear();
    _celularController.clear();
    _layoutController.clear();
    _maxUsosController.text = '10';

    Navigator.pop(context);
    _loadUsers(); // Atualizar a lista após adicionar
  }

  void _mostrarPopupNovoCliente() {
    _nomeController.clear();
    _celularController.clear();
    _layoutController.clear();
    _maxUsosController.text = '10';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Cliente', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Nome', _nomeController),
              _buildTextField('Celular', _celularController),
              _buildTextField('Layout', _layoutController),
              _buildTextField('Número Máximo de Usos', _maxUsosController, keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: _adicionarCliente,
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Cadastrados')),
      body: users.isEmpty
          ? const Center(child: Text('Nenhum usuário cadastrado'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(users[index]['name']),
                      Text(
                        '${users[index]['usos']}/${users[index]['max_usos']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarPopupNovoCliente,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _celularController.dispose();
    _layoutController.dispose();
    _maxUsosController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

class ListaDeCadastrados extends StatefulWidget {
  const ListaDeCadastrados({Key? key}) : super(key: key);

  @override
  _ListaDeCadastradosState createState() => _ListaDeCadastradosState();
}

class _ListaDeCadastradosState extends State<ListaDeCadastrados> {
  List<Map<String, dynamic>> names = const [
    {'nome': 'Guilherme Moreira Sebold', 'usos': 5, 'max_usos': 10},
    {'nome': 'Larissa Fernanda de Campos Dantas', 'usos': 3, 'max_usos': 7},
    {'nome': 'João Paulino da Silva Sauro', 'usos': 8, 'max_usos': 15},
  ];

  final _nomeController = TextEditingController();
  final _celularController = TextEditingController();
  final _layoutController = TextEditingController();
  final _maxUsosController = TextEditingController(text: '10');

  void _adicionarCliente() {
    setState(() {
      names = [
        ...names,
        {
          'nome': _nomeController.text,
          'usos': 0,
          'max_usos': int.parse(_maxUsosController.text),
        }
      ];
      Navigator.pop(context);
    });
  }

  void _mostrarPopupNovoCliente() {
  _nomeController.clear();
  _celularController.clear();
  _layoutController.clear();
  _maxUsosController.text = '10'; // Resetar para valor default

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
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(names[index]['nome']),
                Text(
                  '${names[index]['usos']}/${names[index]['max_usos']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navegação para a próxima página
              // Navigator.push(context, MaterialPageRoute(...));
            },
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
import 'package:flutter/material.dart';
import '../data/database_users.dart';
import './lista_de_cadastrados/image_generator.dart';
import 'package:flutter/services.dart';

class ListaDeCadastrados extends StatefulWidget {
  const ListaDeCadastrados({Key? key}) : super(key: key);

  @override
  _ListaDeCadastradosState createState() => _ListaDeCadastradosState();
}

class _ListaDeCadastradosState extends State<ListaDeCadastrados> {
  List<Map<String, dynamic>> users = [];
  final _dbHelper = DatabaseUser();

  final _nameController = TextEditingController();
  final _celularController = TextEditingController();
  final _layoutController = TextEditingController();
  final _usosController = TextEditingController(text: '0');
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
    if (_nameController.text.isEmpty) return;

  // Criação do Map com os dados
  Map<String, dynamic> user = {
    'name': _nameController.text,
    'celular': _celularController.text,
    'layout': _layoutController.text,
    'usos': int.parse(_usosController.text),
    'max_usos': int.parse(_maxUsosController.text),
  };
    await _dbHelper.addUser(user); // Passando o Map para o método addUser
    // Limpando os campos após adicionar o cliente
    _nameController.clear();
    _celularController.clear();
    _layoutController.clear();
    _usosController.text = '0';
    _maxUsosController.text = '10';
    Navigator.pop(context);
    _loadUsers(); // Atualizar a lista após adicionar
  }

  void _mostrarPopupNovoCliente() {
    _nameController.clear();
    _celularController.clear();
    _layoutController.clear();
    _usosController.text = '0';
    _maxUsosController.text = '10';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Cliente', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Name', _nameController),
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


void _mostrarPopupEdicao(Map<String, dynamic> usuario) {
  _nameController.text = usuario['name'];
  _celularController.text = usuario['celular'];
  _layoutController.text = usuario['layout'];
  _usosController.text = usuario['usos'].toString(); // Preenche os usos
  _maxUsosController.text = usuario['max_usos'].toString();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar Cliente', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Celular', _celularController),
            _buildTextField('Layout', _layoutController),
            _buildTextField('Usos', _usosController),
            _buildTextField('Número Máximo de Usos', _maxUsosController, keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha os botões
            children:[

                // Botão Deletar à esquerda
              ElevatedButton(
                onPressed: () { 
                  _confirmarExclusao(usuario['id']); // Chama a confirmação de exclusão
                },
                child: const Text('Deletar', style: TextStyle(color: Colors.red)),
              ),

              // Botão Salvar à direita
              ElevatedButton(
                onPressed: () {
                  _salvarEdicao(usuario['id']); // Chama a função para salvar
                  Navigator.pop(context); // Fecha a popup de edição
                },
                child: const Text('Salvar'),
              ),

              
              // Botão Adicionar (Aumenta o número de usos)
              /*
              TextButton(
                onPressed: () async {
                  if (int.parse(_usosController.text) >= int.parse(_maxUsosController.text)) {
                    Navigator.pop(context); // Fecha a popup de edição
                    return; // Impede que a popup seja fechada
                  }
                  // Atualiza o campo de usos no banco
                  await _dbHelper.updateUser({
                    'id': usuario['id'],
                    'name': _nameController.text,
                    'celular': _celularController.text,
                    'layout': _layoutController.text,
                    'usos': usuario['usos'] + 1, // Aumenta o valor de 'usos' em 1
                    'max_usos': int.parse(_maxUsosController.text),
                  });
                _loadUsers(); // Atualiza a lista de usuários
                Navigator.pop(context); // Fecha a popup de edição
                },
              child: Text('Adicionar', style: TextStyle(color: Colors.green)),
              ),
              */
            ],
          )
        ],
      );
    },
  );
}


void _mostrarPopupEnviar(Map<String, dynamic> usuario) async {
  final Uint8List? cardImage = await generateCardImage(context, usuario['id']);

  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enviar Cartão', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //cardImage, // A imagem gerada será exibida aqui
            cardImage != null
              ? Image.memory(cardImage)
              : const Text('Erro ao gerar imagem do cartão'),
          ],
        ),
        actions: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.9, // 90% da largura da tela
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha os botões
                children:[
                  // Botão Editar à esquerda
                  ElevatedButton(
                    onPressed: () { 
                      //Navigator.pop(context);
                      _mostrarPopupEdicao(usuario);
                    },
                    child: const Text('Editar', style: TextStyle(color: Colors.red)),
                  ),

                  // Botão Salvar ao centro
                  ElevatedButton(
                    onPressed: () {
                      _salvarEdicao(usuario['id']); // Chama a função para salvar
                      Navigator.pop(context); // Fecha a popup de edição
                    },
                    child: const Text('Reenviar'),
                  ),
                ]
              ),
            ),
          ),
          // Botão Adicionar (Aumenta o número de usos)
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.9, // 90% da largura da tela
              child: ElevatedButton(
                onPressed: () async {
                  if (int.parse(_usosController.text) >= int.parse(_maxUsosController.text)) {
                    Navigator.pop(context); // Fecha a popup de edição
                    return; // Impede que a popup seja fechada
                  }
                // Atualiza o campo de usos no banco
                await _dbHelper.updateUser({
                  'usos': usuario['usos'] + 1, // Aumenta o valor de 'usos' em 1
                });
                _loadUsers(); // Atualiza a lista de usuários
                Navigator.pop(context); // Fecha a popup de edição
              },
              child: Text('Enviar', style: TextStyle(color: Colors.green)),
              ),
            ),
          )
        ],
      );
    }
  );



}


  Future<void> _salvarEdicao(int id) async {
    try {
      // Criação do Map com os dados
      Map<String, dynamic> user = {
        'id': id,
        'name': _nameController.text,
        'celular': _celularController.text,
        'layout': _layoutController.text,
        'usos': int.parse(_usosController.text),
        'max_usos': int.parse(_maxUsosController.text),
      };
      await _dbHelper.updateUser(user);
      //Navigator.pop(context);
      _loadUsers(); // Atualizar a lista de usuários na tela
    } catch (e) {
      print('Deu erro né...');
    }
  }


void _deleteUser(int id) async {
  await _dbHelper.deleteUser(id); // Deleta o usuário do banco de dados
  _loadUsers(); // Atualiza a lista de usuários na tela
}

void _confirmarExclusao(int id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este usuário? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Fecha o alerta
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteUser(id); // Deleta o usuário
              Navigator.pop(context); // Fecha a popup de confirmação
              Navigator.pop(context); // Fecha a popup de edição (caso esteja aberta)
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
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
                trailing: const Icon(Icons.edit),
                onTap: () => _mostrarPopupEnviar(users[index]),
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
    _nameController.dispose();
    _celularController.dispose();
    _layoutController.dispose();
    _usosController.dispose();
    _maxUsosController.dispose();
    super.dispose();
  }
}
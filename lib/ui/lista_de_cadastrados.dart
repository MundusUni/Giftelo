import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/database_users.dart';
import '../data/database_layout.dart';
import './lista_de_cadastrados/image_generator.dart';
import './lista_de_cadastrados/share_image.dart';


class ListaDeCadastrados extends StatefulWidget {
  const ListaDeCadastrados({Key? key}) : super(key: key);

  @override
  _ListaDeCadastradosState createState() => _ListaDeCadastradosState();
}

class _ListaDeCadastradosState extends State<ListaDeCadastrados> {
  List<String> _layoutsDisponiveis = [];
  List<Map<String, dynamic>> users = [];
  Map<String, int> _layoutCircles = {}; // Mapeia nomes de layout para number_of_circles
  final _dbUser = DatabaseUser();
  final _dbLayout = DatabaseLayout();

  final _nameController = TextEditingController();
  final _layoutController = TextEditingController();
  final _usosController = TextEditingController(text: '0');

  // Obtém o número de círculos para um layout específico
  int getNumberOfCircles(String layoutName) {
    return _layoutCircles[layoutName] ?? 0; // Valor padrão caso não encontre
  }

  

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadLayouts();
    _loadLayoutCircles();
  }



  Future<void> _loadUsers() async {
    final data = await _dbUser.getAllUsers();

    // Ordena a lista alfabeticamente pelo campo 'name'
    data.sort((a, b) => a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase()));

    setState(() {
      users = data;
    });
  }



  Future<void> _loadLayouts() async {
    final layouts = await _dbLayout.getAllNames();
    setState(() {
      _layoutsDisponiveis = layouts;
    });
  }



  // Carrega o número de círculos para cada layout
  Future<void> _loadLayoutCircles() async {
    final layouts = await _dbLayout.getAllLayouts();
    final Map<String, int> circlesMap = {};
    
    for (var layout in layouts) {
      String name = layout['name_layout'] as String;
      int circles = layout['number_of_circles'] as int;
      circlesMap[name] = circles;
    }
    
    setState(() {
      _layoutCircles = circlesMap;
    });
  }



  Future<void> _adicionarCliente() async {
    if (_nameController.text.isEmpty) return;

  // Criação do Map com os dados
  Map<String, dynamic> user = {
    'name': _nameController.text,
    'layout': _layoutController.text,
    'usos': int.parse(_usosController.text),
  };
    await _dbUser.addUser(user); // Passando o Map para o método addUser
    // Limpando os campos após adicionar o cliente
    _nameController.clear();
    _layoutController.clear();
    _usosController.text = '0';
    Navigator.pop(context);
    _loadUsers(); // Atualizar a lista após adicionar
  }



  void _mostrarPopupNovoCliente() {
    _nameController.clear();
    _usosController.text = '0';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Cliente', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Nome', _nameController),
              _buildLayoutDropdown(),
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



  Widget _buildLayoutDropdown() {
    final String? dropdownValue = _layoutsDisponiveis.contains(_layoutController.text)
        ? _layoutController.text
        : null;

    return DropdownButtonFormField<String>(
      value: dropdownValue,
      items: _layoutsDisponiveis.map((String layout) {
        return DropdownMenuItem<String>(
          value: layout,
          child: Text(layout),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _layoutController.text = newValue ?? '';
        });
      },
      decoration: const InputDecoration(labelText: 'Layout'),
      hint: const Text(''), // Exibe em branco se valor for null
    );
  }



  void _mostrarPopupEdicao(Map<String, dynamic> usuario) {
    _nameController.text = usuario['name'];
    _layoutController.text = usuario['layout'];
    _usosController.text = usuario['usos'].toString(); // Preenche os usos

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Cliente', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Nome', _nameController),
              _buildLayoutDropdown(),
              _buildTextField('Usos', _usosController),
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
                    Navigator.pop(context); // Fecha a popup de envio
                  },
                  child: const Text('Salvar'),
                ),
              ],
            )
          ],
        );
      },
    );
  }



  void _mostrarPopupEnviar(Map<String, dynamic> usuario) async {
    Uint8List? cardImage;

    try {
      // Mostra um indicador de carregamento enquanto gera a imagem
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Gerando cartão...')
              ],
            ),
          );
        },
      );
      
      // Gera a imagem do cartão com as dimensões originais
      cardImage = await generateCardImage(context, usuario['id']);
      
      // Fecha o diálogo de carregamento
      Navigator.of(context).pop();
    } catch (e) {
      // Fecha o diálogo de carregamento em caso de erro
      Navigator.of(context).pop();
      print('Erro ao gerar imagem do cartão: $e');
      cardImage = null;
    }

    // Exibe o diálogo com o cartão
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        // Calcula as dimensões da tela
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Calcula o tamanho máximo disponível mantendo a proporção do cartão
        final double aspectRatio = 400 / 180;
        final double maxWidth = screenWidth * 0.85; // 85% da largura da tela
        final double maxHeight = screenHeight * 0.5; // 50% da altura da tela
        
        // Calcula as dimensões finais mantendo a proporção
        double displayWidth = maxWidth;
        double displayHeight = displayWidth / aspectRatio;
        
        // Se a altura calculada exceder o máximo, ajusta baseado na altura
        if (displayHeight > maxHeight) {
          displayHeight = maxHeight;
          displayWidth = displayHeight * aspectRatio;
        }
        
        return AlertDialog(
          title: const Text('Enviar Cartão', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cardImage != null)
                  Container(
                    width: displayWidth,
                    height: displayHeight,
                    child: Image.memory(
                      cardImage,
                      fit: BoxFit.contain,
                      // A imagem mantém suas proporções exatas de 400x180
                    ),
                  )
                else
                  const Text('Não foi possível carregar o cartão.\nVerifique se o layout ainda existe.'),
              ],
            ),
          ),
          actions: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.9, // 90% da largura da tela
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botão Editar à esquerda
                    ElevatedButton(
                      onPressed: () {
                        _mostrarPopupEdicao(usuario);
                      },
                      child: const Text('Editar', style: TextStyle(color: Colors.red)),
                    ),

                    // Botão Reenviar ao centro
                    
                    ElevatedButton(
                      onPressed: () async {
                        // Mostra mensagem se atingiu o limite
                        if (usuario['usos'] >= getNumberOfCircles(usuario['layout'])) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Limite de usos atingido!')),
                          );
                          Navigator.pop(context);
                          return;
                        }

                        Navigator.pop(context); // Fecha a popup

                        // Atualiza o campo de usos no banco
                        await _dbUser.updateUser({
                          'id': usuario['id'],
                          'usos': usuario['usos'] + 1,
                        });

                        _loadUsers(); // Atualiza a lista de usuários

                        // Recarrega o usuário atualizado
                        final usuarioAtualizado = await _dbUser.getUserById(usuario['id']);

                        // Reabre a popup com os dados atualizados
                        if (usuarioAtualizado != null) {
                          _mostrarPopupEnviar(usuarioAtualizado);
                        }

                      },
                      child: const Text('+ 1'),
                    ),
                    
                    
                  ]
                ),
              ),
            ),
            // Botão Enviar (Aumenta o número de usos)
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    
                    shareImageToWhatsApp(cardImage!);
                    
                    Navigator.pop(context);

                                        // Feedback visual de que o cartão foi enviado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cartão enviado com sucesso!')),
                    );
                    
                  },
                  child: const Text('Enviar', style: TextStyle(color: Colors.green)),
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
        'layout': _layoutController.text,
        'usos': int.parse(_usosController.text),
      };
      await _dbUser.updateUser(user);
      //Navigator.pop(context);
      _loadUsers(); // Atualizar a lista de usuários na tela
    } catch (e) {
      print('Deu erro né...');
    }
  }



  void _deleteUser(int id) async {
    await _dbUser.deleteUser(id); // Deleta o usuário do banco de dados
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
                Navigator.pop(context);
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
                        '${users[index]['usos']}/${getNumberOfCircles(users[index]['layout'])}',
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
    _layoutController.dispose();
    _usosController.dispose();
    super.dispose();
  }
}
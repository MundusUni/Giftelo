import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/pages/login.dart'; // Substitua pelo caminho correto da sua tela de login

class Config extends StatelessWidget {
  const Config({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Você tem certeza que deseja realizar o Logout?'),
          actions: [
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o popup
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Fecha o popup
                await FirebaseAuth.instance.signOut(); // Faz logout

                // Retorna para a tela de login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showLogoutDialog(context),
          child: const Text("Logout"),
        ),
      ),
    );
  }
}

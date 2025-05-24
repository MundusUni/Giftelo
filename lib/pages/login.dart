import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/home_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';



Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger o fluxo de login
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null; // Cancelado pelo usuário

    // Obtenha os detalhes de autenticação
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Crie um novo credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Autentique com o Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Erro ao fazer login com Google: $e');
    return null;
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00284F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'lib/assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.5, // ajuste conforme o tamanho ideal
                ),
              const SizedBox(height: 48), // Espaço entre a logo e o botão
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SignInButton(
                  Buttons.Google,
                  text: "Entrar com Google",
                  onPressed: () async {
                    final userCredential = await signInWithGoogle();
                    if (userCredential != null) {
                      final user = userCredential.user;
          
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bem-vindo, ${user?.displayName ?? 'usuário'}!')),
                      );
          
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Falha no login. Tente novamente.')),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
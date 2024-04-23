import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/formulaire_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
void _signUp() async {
  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Si l'inscription réussit, redirigez l'utilisateur vers MuscleFormPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FormulairePage(),
      ),
    );

    print('Inscription réussie : ${userCredential.user}');
  } catch (e) {
    print('Erreur lors de l\'inscription : $e');
    // Vous pouvez afficher une alerte ou un message à l'utilisateur ici
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _signUp,
            child: Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }
}

WelcomePage({required String email}) {
}

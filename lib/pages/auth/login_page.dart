import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/formulaire_page.dart';
import 'package:test/pages/auth/signup_page.dart'; // Assurez-vous que le chemin est correct

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Si la connexion est réussie, redirigez vers la page principale
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FormulairePage()), // Utilisez le widget de votre page principale
        );
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      // Vous pouvez afficher une alerte ou un Snackbar ici pour informer l'utilisateur
    }
  }

  void _sendPasswordResetEmail() {
    var email = _emailController.text.trim();
    if (email.isNotEmpty) {
      _auth.sendPasswordResetEmail(email: email).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lien de réinitialisation envoyé à $email"))
        );
      }).catchError((error) {
        print('Erreur d’envoi de l’email de réinitialisation : $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'envoi de l'email"))
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signInWithEmailAndPassword();
                }
              },
              child: Text('Se connecter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text("S'inscrire"),
            ),
            TextButton(
              onPressed: _sendPasswordResetEmail,
              child: Text("Mot de passe oublié ?"),
            ),
          ],
        ),
      ),
    );
  }
}

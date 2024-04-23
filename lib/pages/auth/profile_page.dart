import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Defines the ProfilePage widget
class ProfilePage extends StatelessWidget {
  // Cette fonction gère la déconnexion
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Redirige l'utilisateur vers la page de connexion après la déconnexion
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOut(context), // Appel de la fonction de déconnexion
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Center(
        child: Text('This is the profile page. Display user information here.'),
      ),
    );
  }
}

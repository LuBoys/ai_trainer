import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import de SharedPreferences

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  // Fonction pour enregistrer l'état de déconnexion de l'utilisateur
  Future<void> _saveLogoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = _auth.currentUser?.email ?? '';
  }

  Future<void> _updateEmail() async {
    try {
      // Envoi d'un e-mail de vérification à la nouvelle adresse e-mail
      await _auth.currentUser?.verifyBeforeUpdateEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Un e-mail de vérification a été envoyé à la nouvelle adresse e-mail')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  Future<void> _updatePassword() async {
    try {
      // On doit d'abord re-authentifier l'utilisateur
      User user = _auth.currentUser!;
      String email = user.email!;
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Ensuite, on peut mettre à jour le mot de passe
      await user.updatePassword(_newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mot de passe mis à jour')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await _saveLogoutState(); // Enregistrement de l'état de déconnexion
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
            onPressed: () => signOut(context),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Adresse e-mail'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateEmail,
              child: Text('Mettre à jour l\'adresse e-mail'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: 'Mot de passe actuel'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_currentPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty) {
                  _updatePassword();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez saisir le mot de passe actuel et le nouveau mot de passe')),
                  );
                }
              },
              child: Text('Mettre à jour le mot de passe'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}

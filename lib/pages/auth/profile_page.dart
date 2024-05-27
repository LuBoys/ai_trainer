import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../navigation_bar_with_controller.dart'; // Chemin relatif correct

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

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
      User user = _auth.currentUser!;
      String email = user.email!;
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

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
    await _saveLogoutState();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Enlever la flèche de retour
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOut(context),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 400), // Limite la largeur maximale
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'MODIFIER LE PROFIL',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Adresse e-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _updateEmail,
                          child: Text('Mettre à jour l\'adresse e-mail'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _currentPasswordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Mot de passe actuel',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: 'Nouveau mot de passe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
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
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWithController(selectedIndex: 2), // Ajout du menu de navigation
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

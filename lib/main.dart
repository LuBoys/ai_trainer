import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/firebase_options.dart';  // Assurez-vous que ce chemin est correct
import 'package:test/pages/auth/login_page.dart'; // Vérifiez ce chemin également
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/pages/home_page.dart'; // Assurez-vous d'ajouter ce chemin
import 'package:test/pages/auth/profile_page.dart';  // Assurez-vous d'avoir cette page
import 'package:test/mes_programmes.dart'; // Assurez-vous d'avoir cette page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(auth: auth),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/mesProgrammes': (context) => MesProgrammesPage(programmeText: '',),  // Assurez-vous que cette page est définie
        '/profil': (context) => ProfilePage(),  // Assurez-vous que cette page est définie
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final FirebaseAuth auth;

  AuthWrapper({required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage(); // Redirige vers LoginPage si aucun utilisateur n'est connecté
          }
          return HomePage(); // Redirige vers HomePage si un utilisateur est connecté
        }
        // Affiche un indicateur de chargement pendant la vérification de l'état de connexion
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

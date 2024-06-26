import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/firebase_options.dart';
import 'package:test/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/pages/home_page.dart';
import 'package:test/pages/auth/profile_page.dart';
import 'package:test/mes_programmes.dart';
import 'package:test/formulaire_page.dart'; // Importez la page du formulaire

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
        '/mesProgrammes': (context) => MesProgrammesPage(),
        '/profil': (context) => ProfilePage(),
        '/formulaire': (context) => FormulairePage(), // Assurez-vous que cette route est définie
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
            return LoginPage();
          }
          return HomePage();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

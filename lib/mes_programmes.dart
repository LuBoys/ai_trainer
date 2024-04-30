import 'package:flutter/material.dart';

class MesProgrammesPage extends StatelessWidget {
  final String programmeText;

  MesProgrammesPage({required this.programmeText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Programmes"),
      ),
      body: SingleChildScrollView(  // Utilisation de SingleChildScrollView pour la défilement
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(programmeText),
        ),
      ),
    );
  }
}


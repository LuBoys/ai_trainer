import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MesProgrammesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Programmes"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('generatedPrograms').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title'] ?? "No Title"), // Assuming 'title' is part of your stored data
                subtitle: Text(data['content'] ?? "No Content"), // Assuming 'content' is part of your stored data
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

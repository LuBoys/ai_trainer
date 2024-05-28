import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'navigation_bar_with_controller.dart';

class FormulairePage extends StatefulWidget {
  @override
  _FormulairePageState createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  String? sexe;
  int? poids;
  String? objectif;
  Set<String> partiesMusculaires = {};
  int? nombreJours;
  String? intensite;
  String? typeSeance;
  String? formatEntrainement;
  double? tempsEntrainementHeure;
  String? niveauExperience;
  bool inclureCardio = false;
  bool aAccesEquipement = false;
  bool aRestrictions = false;
  final TextEditingController _detailsEquipementController = TextEditingController();
  final TextEditingController _detailsRestrictionsController = TextEditingController();

  final List<String> optionsGroupesMusculaires = [
    "Biceps", "Triceps", "Dos", "Pectoraux", "Épaules", "Abdominaux", "Jambes"
  ];

  final List<String> tousLesTypesSeance = [
    "Endurance de force", "Puissance", "Force max", "Hypertrophie",
  ];

  final List<String> tousLesFormatsEntrainement = [
    "PPL", "Split", "Full body", "Upper - Lower",
  ];

  final List<String> optionsNiveauExperience = [
    "Débutant", "Intermédiaire", "Avancé",
  ];

  @override
  void dispose() {
    _detailsEquipementController.dispose();
    _detailsRestrictionsController.dispose();
    super.dispose();
  }

  void submitFormData() async {
    Map<String, dynamic> formData = {
      'sexe': sexe,
      'poids': poids,
      'objectif': objectif,
      'partiesMusculaires': partiesMusculaires.toList(),
      'nombreJours': nombreJours,
      'intensite': intensite,
      'typeSeance': typeSeance,
      'formatEntrainement': formatEntrainement,
      'tempsEntrainement': tempsEntrainementHeure,
      'inclureCardio': inclureCardio,
      'niveauExperience': niveauExperience,
      'aAccesEquipement': aAccesEquipement,
      'aRestrictions': aRestrictions,
      'detailsEquipement': _detailsEquipementController.text,
      'detailsRestrictions': _detailsRestrictionsController.text
    };

       FirebaseFirestore.instance.collection('formResponses').add(formData).then((documentReference) async {
      print("Document ajouté avec l'ID: ${documentReference.id}");
      await sendFormDataToAPI(formData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Données du formulaire soumises avec succès!'))
      );
    }).catchError((e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la soumission des données.'))
      );
    });
  }

  Future<void> sendFormDataToAPI(Map<String, dynamic> formData) async {
    try {
      final response = await http.post(
        Uri.parse('https://ai-trainer-kohl.vercel.app/api/generate-program'), // Mettez à jour l'URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'data': formData}),
      );

      if (response.statusCode == 200) {
        final programme = jsonDecode(response.body);
        print('Programme reçu: $programme');

        // Enregistrez le programme généré dans Firestore
        await FirebaseFirestore.instance.collection('generatedPrograms').add({
          'title': 'Programme généré',
          'content': programme['result'],  // assuming 'result' contains the generated program text
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Affichez une notification de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Programme de musculation généré avec succès!'))
        );
      } else {
        // Affichez une notification d'échec
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la génération du programme: ${response.body}'))
        );
      }
    } catch (error) {
      // Gestion des erreurs
      print('Erreur lors de l\'envoi des données au serveur: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi des données au serveur'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Désactive le bouton de retour
        title: Text("Formulaire de Musculation"),
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
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informations générales",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: Text('Homme'),
                            value: 'homme',
                            groupValue: sexe,
                            onChanged: (value) => setState(() => sexe = value),
                          ),
                          RadioListTile<String>(
                            title: Text('Femme'),
                            value: 'femme',
                            groupValue: sexe,
                            onChanged: (value) => setState(() => sexe = value),
                          ),
                          DropdownButtonFormField<int>(
                            value: poids,
                            onChanged: (newValue) => setState(() => poids = newValue),
                            items: List.generate(151, (index) => 30 + index).map<DropdownMenuItem<int>>((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text("$value kg"),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Poids (en kg)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Détails de l'entraînement",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: nombreJours,
                            onChanged: (newValue) => setState(() => nombreJours = newValue),
                            items: List.generate(7, (index) => index + 1).map<DropdownMenuItem<int>>((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text("$value jours par semaine"),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Nombre de séances par semaine',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: niveauExperience,
                            onChanged: (newValue) => setState(() => niveauExperience = newValue),
                            items: optionsNiveauExperience.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Niveau d\'expérience',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<double>(
                            value: tempsEntrainementHeure,
                            onChanged: (newValue) => setState(() => tempsEntrainementHeure = newValue),
                            items: <double>[0.5, 1.0, 1.5, 2.0, 2.5, 3.0].map<DropdownMenuItem<double>>((value) {
                              return DropdownMenuItem<double>(
                                value: value,
                                child: Text("$value heures"),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Temps d\'entraînement par séance',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          CheckboxListTile(
                            title: Text("Inclure du cardio"),
                            value: inclureCardio,
                            onChanged: (bool? value) => setState(() => inclureCardio = value!),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Groupes musculaires à travailler",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: optionsGroupesMusculaires.map((muscle) {
                          return CheckboxListTile(
                            title: Text(muscle),
                            value: partiesMusculaires.contains(muscle),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  partiesMusculaires.add(muscle);
                                } else {
                                  partiesMusculaires.remove(muscle);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: typeSeance,
                        onChanged: (newValue) => setState(() => typeSeance = newValue),
                        items: tousLesTypesSeance.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Type de séance',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: [
                          Text(
                            "Format d'entraînement",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: formatEntrainement,
                            onChanged: (newValue) => setState(() => formatEntrainement = newValue),
                            items: tousLesFormatsEntrainement.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Format d\'entraînement',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text("Accès à l'équipement"),
                        value: aAccesEquipement,
                        onChanged: (bool value) {
                          setState(() {
                            aAccesEquipement = value;
                          });
                        },
                      ),
                      Visibility(
                        visible: aAccesEquipement,
                        child: TextFormField(
                          controller: _detailsEquipementController,
                          decoration: InputDecoration(
                            labelText: "Dites-nous où vous vous entraînez (salle, maison, parc)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text("Restrictions ou blessures"),
                        value: aRestrictions,
                        onChanged: (bool value) {
                          setState(() {
                            aRestrictions = value;
                          });
                        },
                      ),
                      Visibility(
                        visible: aRestrictions,
                        child: TextFormField(
                          controller: _detailsRestrictionsController,
                          decoration: InputDecoration(
                            labelText: "Détaillez vos restrictions ou blessures",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: submitFormData,
                          child: Text('Soumettre'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
      bottomNavigationBar: NavigationBarWithController(selectedIndex: 1),
    );
  }
}

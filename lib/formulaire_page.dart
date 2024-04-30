import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navigation_bar_with_controller.dart'; // Assurez-vous que le chemin d'importation est correct

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
  bool inclureCardio = false;
  String? niveauExperience;
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

  void submitFormData() {
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

    FirebaseFirestore.instance.collection('formResponses').add(formData).then((documentReference) {
      print("Document ajouté avec l'ID: ${documentReference.id}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulaire de Musculation"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Informations générales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              DropdownButton<int>(
                value: poids,
                onChanged: (newValue) => setState(() => poids = newValue),
                items: List.generate(151, (index) => 30 + index).map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value kg"),
                  );
                }).toList(),
                hint: Text('Poids (en kg)'),
              ),
              Text("Détails de l'entraînement", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              DropdownButton<int>(
                value: nombreJours,
                onChanged: (newValue) => setState(() => nombreJours = newValue),
                items: List.generate(7, (index) => index + 1).map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value jours par semaine"),
                  );
                }).toList(),
                hint: Text('Nombre de séances par semaine'),
              ),
              CheckboxListTile(
                title: Text("Inclure du cardio"),
                value: inclureCardio,
                onChanged: (bool? value) => setState(() => inclureCardio = value!),
              ),
              Text("Groupes musculaires à travailler", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ...optionsGroupesMusculaires.map((muscle) {
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
              DropdownButton<String>(
                value: niveauExperience,
                onChanged: (newValue) => setState(() => niveauExperience = newValue),
                items: optionsNiveauExperience.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Niveau d\'expérience'),
              ),
              DropdownButton<String>(
                value: typeSeance,
                onChanged: (newValue) => setState(() => typeSeance = newValue),
                items: tousLesTypesSeance.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Type de séance'),
              ),
              DropdownButton<String>(
                value: formatEntrainement,
                onChanged: (newValue) => setState(() => formatEntrainement = newValue),
                items: tousLesFormatsEntrainement.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Format d\'entraînement'),
              ),
              DropdownButton<double>(
                value: tempsEntrainementHeure,
                onChanged: (newValue) => setState(() => tempsEntrainementHeure = newValue),
                items: <double>[0.5, 1.0, 1.5, 2.0, 2.5, 3.0].map<DropdownMenuItem<double>>((value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text("$value heures"),
                  );
                }).toList(),
                hint: Text('Temps d\'entraînement par séance'),
              ),
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
                  ),
                ),
              ),
              SwitchListTile(
                title: Text("Restrictions ou blessures"),
                value: aRestrictions,
                onChanged: (bool value) {
                  setState(() {
                    aRestrictions = value;
                  });
                }),
              Visibility(
                visible: aRestrictions,
                child: TextFormField(
                  controller: _detailsRestrictionsController,
                  decoration: InputDecoration(
                    labelText: "Détaillez vos restrictions ou blessures",
                  ),
                ),
              ),
              SizedBox(height: 20),
             Center(
  child: ElevatedButton(
    onPressed: submitFormData, // Ici, vous appelez la fonction de soumission lorsque le bouton est pressé.
    child: Text('Soumettre'),
  ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWithController(selectedIndex: 1),  // Index pour cette page
    );
  }
}

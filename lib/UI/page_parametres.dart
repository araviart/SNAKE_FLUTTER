import 'package:flutter/material.dart';
import 'package:flutter_snake/models/parametres.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageParametres extends StatefulWidget {
  @override
  _PageParametresState createState() => _PageParametresState();
}

class _PageParametresState extends State<PageParametres> {
  String difficulte = 'Facile';
  bool mursPresents = false;
  bool nourritureIllimitee = false;

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulte', difficulte);
    await prefs.setBool('mursPresents', mursPresents);
    await prefs.setBool('nourritureIllimitee', nourritureIllimitee);
    Provider.of<Parametres>(context, listen: false)
      ..setDifficulte(difficulte)
      ..setMursPresents(mursPresents)
      ..setNourritureIllimitee(nourritureIllimitee);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      difficulte = prefs.getString('difficulte') ?? 'Facile';
      mursPresents = prefs.getBool('mursPresents') ?? false;
      nourritureIllimitee = prefs.getBool('nourritureIllimitee') ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Difficulté'),
            trailing: DropdownButton<String>(
              value: difficulte,
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    difficulte = newValue;
                    _saveSettings();
                  }
                });
              },
              items: <String>['Facile', 'Moyen', 'Difficile']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SwitchListTile(
            title: Text('Murs'),
            value: mursPresents,
            onChanged: (value) {
              setState(() {
                mursPresents = value;
                _saveSettings();
              });
            },
            secondary: const Text('🧱'),
          ),
          SwitchListTile(
            title: Text('Nombre de nourriture illimité'),
            value: nourritureIllimitee,
            onChanged: (value) {
              setState(() {
                nourritureIllimitee = value;
                _saveSettings();
              });
            },
            secondary: const Text('🍎'),
          ),
        ],
      ),
    );
  }
}

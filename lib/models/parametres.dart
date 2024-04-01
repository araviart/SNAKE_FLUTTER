import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parametres with ChangeNotifier {
  String difficulte = 'Facile';
  bool mursPresents = false;
  bool nourritureIllimitee = false;

  String get getDifficulte => difficulte;
  bool get getMursPresents => mursPresents;
  bool get getNourritureIllimitee => nourritureIllimitee;

  loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    difficulte = prefs.getString('difficulte') ?? 'Facile';
    mursPresents = prefs.getBool('mursPresents') ?? false;
    nourritureIllimitee = prefs.getBool('nourritureIllimitee') ?? false;
    notifyListeners();
  }

  setDifficulte(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulte', value);
    difficulte = value;
    notifyListeners();
  }

  setMursPresents(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mursPresents', value);
    mursPresents = value;
    notifyListeners();
  }

  setNourritureIllimitee(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('nourritureIllimitee', value);
    nourritureIllimitee = value;
    notifyListeners();
  }

  getCouleurCase({bool isPair = false}) {
    switch (difficulte) {
      case 'Facile':
        return isPair ? Colors.lightGreen.shade400 : Colors.lightGreen;
      case 'Moyen':
        return isPair ? Colors.green.shade800 : Colors.green.shade900;
      case 'Difficile':
        return isPair ? Colors.black87 : Colors.black;
    }
  }

  getCouleurMur() {
    switch (difficulte) {
      case 'Facile':
        return Colors.grey.shade900;
      case 'Moyen':
        return Colors.black;
      case 'Difficile':
        return Colors.grey;
    }
  }
}

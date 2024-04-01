import 'package:flutter/material.dart';

class RegleSnakePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Règles du jeu Snake'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              '1. Le joueur contrôle un serpent qui grandit en mangeant des pommes.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '2. Le serpent se déplace constamment et le joueur ne peut que contrôler la direction de son mouvement.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '3. Le jeu se termine lorsque le serpent se heurte à lui-même ou au bord de l\'écran.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '4. Le but du jeu est de manger autant de pommes que possible pour obtenir le score le plus élevé.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

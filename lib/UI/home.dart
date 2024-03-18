import 'package:flutter/material.dart';
import 'package:flutter_snake/ui/snake_page.dart';
import 'package:flutter_snake/ui/classement_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SnakePage(),
    ClassementPage(),
  ];
  //  on met les pages ici après

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Jouer'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SnakePage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Classement'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClassementPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Règles'),
              onPressed: () {
                // Remplacez ceci par la navigation vers votre page de règles
              },
            ),
          ],
        ),
      ),
    );
  }
}

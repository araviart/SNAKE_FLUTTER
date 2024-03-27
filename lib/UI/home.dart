import 'package:flutter/material.dart';
import 'package:flutter_snake/models/parametres.dart';
import 'package:flutter_snake/ui/snake_page.dart';
import 'package:flutter_snake/ui/classement_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';

class MyHomePage extends StatefulWidget {
  final Future<Database> database;

  const MyHomePage({Key? key, required this.database}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  int _userId = 0;
  late List<Widget> _children; // Declare _children as late
  late Database db;
  String username = '';

  @override
  void initState() {
    super.initState();
    Provider.of<Parametres>(context, listen: false).loadSettings();
    widget.database.then((database) {
      db = database;
      _showUsernameDialog();
      _children = [
        // Initialize _children here
        SnakePage(
          userId: _userId,
          database: widget.database,
        ),
        ClassementPage(database: widget.database),
      ];
    });
  }

  void _showUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Entrez votre pseudonyme : '),
          content: TextField(
            onChanged: (value) {
              username = value;
            },
          ),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                _userId = await db.insert(
                  'users',
                  {'name': username},
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
                setState(() {}); // Add this line
              },
            ),
          ],
        );
      },
    );
  }

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
            Text('Bienvenue $username'),
            ElevatedButton(
              child: Text('Jouer'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SnakePage(userId: _userId, database: widget.database),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Classement'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ClassementPage(database: widget.database),
                  ),
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

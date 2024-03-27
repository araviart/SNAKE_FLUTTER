import 'package:flutter/material.dart';
import 'package:flutter_snake/UI/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'snake_database.db'),
    onCreate: (db, version) async {
      print('onCreate called.');
      await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)',
      );
      await db.execute(
        'CREATE TABLE scores(id INTEGER PRIMARY KEY, userId INTEGER, score INTEGER, FOREIGN KEY(userId) REFERENCES users(id))',
      );
      await db.execute(
        'CREATE TABLE classement(id INTEGER PRIMARY KEY, userId INTEGER, score INTEGER, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(score) REFERENCES scores(id))',
      );
      print('Tables created successfully.'); // Debug message
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS scores');
      await db.execute('DROP TABLE IF EXISTS classement');
      await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)',
      );
      await db.execute(
        'CREATE TABLE scores(id INTEGER PRIMARY KEY, userId INTEGER, score INTEGER, FOREIGN KEY(userId) REFERENCES users(id))',
      );
      await db.execute(
        'CREATE TABLE classement(id INTEGER PRIMARY KEY, userId INTEGER, score INTEGER, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(score) REFERENCES scores(id))',
      );
    },
    version: 2,
  );
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(database: database),
    );
  }
}

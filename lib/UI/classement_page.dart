import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter/material.dart';

class ClassementPage extends StatefulWidget {
  final Future<Database> database;

  const ClassementPage({Key? key, required this.database}) : super(key: key);
  @override
  _ClassementPageState createState() => _ClassementPageState();
}

class _ClassementPageState extends State<ClassementPage> {
  late Future<List<Map<String, dynamic>>> futureClassement;
  String difficulte = 'Facile';
  bool mursPresents = false;
  bool nourritureIllimitee = false;

  @override
  void initState() {
    super.initState();
    futureClassement = getClassement();
  }

  Future<List<Map<String, dynamic>>> getClassement() async {
    final db = await widget.database;
    String query =
        'SELECT users.name, classement.score FROM classement INNER JOIN users ON classement.userId = users.id WHERE classement.difficulte = ? AND classement.murs = ? AND classement.nourritureIllimite = ? ORDER BY score DESC';
    var result = await db.rawQuery(
        query, [difficulte, mursPresents ? 1 : 0, nourritureIllimitee ? 1 : 0]);

    for (var row in result) {
      print("${row['name']}: ${row['score']} diff: $difficulte murs: $mursPresents nourriture: $nourritureIllimitee");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classement'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureClassement,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Container(
                  // hauteur: 40% de la hauteur de l'écran
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text('Difficulté'),
                        trailing: DropdownButton<String>(
                          value: difficulte,
                          onChanged: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                difficulte = newValue;
                                futureClassement = getClassement();
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
                            futureClassement = getClassement();
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
                            futureClassement = getClassement();
                          });
                        },
                        secondary: const Text('🍎'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey.shade200),
                        columns: const [
                          DataColumn(label: Text('Position')),
                          DataColumn(label: Text('Pseudo')),
                          DataColumn(label: Text('Score')),
                        ],
                        rows: List<DataRow>.generate(
                          snapshot.data!.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(
                                  Text('${snapshot.data![index]['name']}')),
                              DataCell(
                                  Text('${snapshot.data![index]['score']}')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    futureClassement = getClassement();
  }

  Future<List<Map<String, dynamic>>> getClassement() async {
    final db = await widget.database;
    return db.rawQuery('SELECT * FROM classement ORDER BY score DESC');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureClassement,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return DataTable(
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
                  DataCell(Text('${snapshot.data![index]['userId']}')),
                  DataCell(Text('${snapshot.data![index]['score']}')),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

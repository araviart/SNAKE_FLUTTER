import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_snake/UI/home.dart';
import 'package:flutter_snake/UI/page_parametres.dart';
import 'package:flutter_snake/models/game_model.dart';
import 'package:flutter_snake/models/parametres.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class SnakePage extends StatefulWidget {
  final int userId;
  final Future<Database> database;

  const SnakePage({Key? key, required this.userId, required this.database})
      : super(key: key);

  @override
  State<SnakePage> createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  GameModel gameModel = GameModel();
  Timer? timer;
  bool isPaused = false;
  late Database db;
  int timerText = -1;

  @override
  void initState() {
    // TODO: implement initState

    //print("start");
    //startGame();
  }

  void pauseGame() {
    timer?.cancel();
    isPaused = true;
  }

  void resumeGame() {
    createTimer();
    isPaused = false;
  }

  Future<void> updateRanking() async {
    final Database db = await widget.database;
    int score = gameModel.score;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM classement WHERE userId = ? AND difficulte = ? AND murs = ? AND nourritureIllimite = ?',
        [
          widget.userId,
          GameModel().difficulte,
          GameModel().mursPresents ? 1 : 0,
          GameModel().nourritureIllimitee ? 1 : 0
        ]);

    if (list.isNotEmpty) {
      if (list[0]['score'] < score) {
        await db.update(
          'classement',
          {
            'score': score,
            'difficulte': GameModel().difficulte,
            'murs': GameModel().mursPresents ? 1 : 0,
            'nourritureIllimite': GameModel().nourritureIllimitee ? 1 : 0
          },
          where:
              'userId = ? AND difficulte = ? AND murs = ? AND nourritureIllimite = ?',
          whereArgs: [
            widget.userId,
            GameModel().difficulte,
            GameModel().mursPresents ? 1 : 0,
            GameModel().nourritureIllimitee ? 1 : 0
          ],
        );
      }
    } else {
      await db.insert(
        'classement',
        {
          'userId': widget.userId,
          'score': score,
          'difficulte': GameModel().difficulte,
          'murs': GameModel().mursPresents ? 1 : 0,
          'nourritureIllimite': GameModel().nourritureIllimitee ? 1 : 0
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // permet d'afficher 3, 2, 1, GO
  void createTimerText() {
    timerText = 5;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerText > -1) {
          timerText--;
          if (timerText == 0) {
            startGame();
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  void createTimer() {
    timer = Timer.periodic(Duration(milliseconds: gameModel.getTickRate()),
        (timer) {
      setState(() {
        if (gameModel.moveSnake()) {
          timer.cancel();
          showGameOverDialog(context);
        }
      });
    });
  }

  void startGame() {
    gameModel.start();
    resetTimer();
  }

  void resetTimer() {
    timer?.cancel();
    createTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future<void> insertScore() async {
    int score = gameModel.score;
    final Database db = await widget.database;

    // print la difficulté, les murs et la nourriture illimitée
    print('Difficulte: ' +
        gameModel.difficulte +
        ', Murs: ' +
        gameModel.mursPresents.toString() +
        ', Nourriture illimitee: ' +
        gameModel.nourritureIllimitee.toString());

    await db.insert(
      'scores',
      {
        'userId': widget.userId,
        'score': score,
        'difficulte': gameModel.difficulte,
        'murs': gameModel.mursPresents ? 1 : 0,
        'nourritureIllimite': gameModel.nourritureIllimitee ? 1 : 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // on va get tous les scores et les print

    // on va tout suppr de classement et score

    List<Map> list = await db.rawQuery('SELECT * FROM classement');
    for (var row in list) {
      print(
          'UserId: ${row['userId']}, Score: ${row['score']}, Difficulte: ${row['difficulte']}, Murs: ${row['murs']}, Nourriture illimite: ${row['nourritureIllimite']}');
    }
  }

  Future<int> getBestScore() async {
    final Database db = await widget.database;
    List<Map> list = await db.rawQuery(
        'SELECT MAX(score) as bestScore FROM scores WHERE userId = ? AND difficulte = ? AND murs = ? AND nourritureIllimite = ?',
        [
          widget.userId,
          gameModel.difficulte,
          gameModel.mursPresents ? 1 : 0,
          gameModel.nourritureIllimitee ? 1 : 0
        ]);
    if (list.isNotEmpty && list[0]['bestScore'] != null) {
      return list[0]['bestScore'];
    } else {
      return 0;
    }
  }

  Future<List<Map>> getScoreHistory() async {
    final Database db = await widget.database;
    List<Map> list = await db.rawQuery(
        'SELECT score FROM scores WHERE userId = ? AND difficulte = ? AND murs = ? AND nourritureIllimite = ? ORDER BY score DESC',
        [
          widget.userId,
          gameModel.difficulte,
          gameModel.mursPresents ? 1 : 0,
          gameModel.nourritureIllimitee ? 1 : 0
        ]);
    return list;
  }

  void showGameOverDialog(BuildContext context) {
    insertScore().then((_) {
      updateRanking();
      Future.wait([getBestScore(), getScoreHistory()]).then((results) {
        int bestScore = results[0] as int;
        List<Map> scoreHistory = results[1] as List<Map>;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Votre score: ' + gameModel.score.toString()),
                      SizedBox(height: 10),
                      Text('Votre meilleur score: ' + bestScore.toString()),
                      SizedBox(height: 10),
                      Text('Historique des scores: '),
                      ...scoreHistory.map((score) => Column(
                            children: [
                              Text('Score: ${score['score']}'),
                            ],
                          )),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Retour'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Rejouer'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        startGame();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // TODO: Implement your back button logic here
            Navigator.pop(context);
          },
        ),
        title: Text('Snake Game. Score: ' + gameModel.score.toString()),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              // TODO: Implement your menu actions here
            },
            onOpened: () {
              if (timer != null) timer!.cancel();
            },
            onCanceled: () {
              if (!isPaused && gameModel.isGameRunning) {
                createTimer();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: isPaused ? "Reprendre" : 'Pause',
                onTap: () => {
                  setState(() {
                    if (isPaused) {
                      resumeGame();
                    } else {
                      pauseGame();
                    }
                  })
                },
                child: Text(isPaused ? "Reprendre" : 'Pause'),
              ),
              PopupMenuItem<String>(
                value: 'Replay',
                onTap: () {
                  timer!.cancel();
                  createTimerText();
                },
                child: Text('Rejouer'),
              ),
              PopupMenuItem<String>(
                value: 'Paramètres',
                onTap: () {
                  setState(() {
                    pauseGame();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PageParametres()),
                    );
                  });
                },
                child: Text('Paramètres'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 7,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            10, // Change this number as per your need
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        int y = index ~/ GameModel.NB_COLONNES;
                        int x = index -
                            ((index ~/ GameModel.NB_COLONNES) *
                                GameModel.NB_COLONNES);

                        Color cellColor;

                        switch (gameModel.grid[y][x]) {
                          case GameModel.SNAKE_HEAD:
                            cellColor = Colors.blue.shade900;
                            break;
                          case GameModel.SNAKE_BODY:
                            cellColor = Colors.blue.shade800;
                            break;
                          case GameModel.FOOD:
                            print(index.toString() +
                                " " +
                                x.toString() +
                                " " +
                                y.toString());
                            cellColor = Colors.red;
                            break;
                          case GameModel.WALL:
                            cellColor = Provider.of<Parametres>(context)
                                .getCouleurMur();
                            break;
                          default:
                            cellColor = ((x + y) % 2) == 0
                                ? Provider.of<Parametres>(context,
                                        listen: false)
                                    .getCouleurCase()
                                : Provider.of<Parametres>(context,
                                        listen: false)
                                    .getCouleurCase(isPair: true);
                        }

                        return GridTile(
                          child: Container(
                            decoration: BoxDecoration(
                              color: cellColor,
                              //border: Border.all(color: Colors.white),
                            ),
                            // TODO: Add your game cell here
                          ),
                        );
                      },
                      itemCount: GameModel
                          .NB_CASES, // Change this number as per your need
                    ),
                  ),
                  Positioned(
                      child: Expanded(
                        child: (!gameModel.isGameRunning && timerText == -1)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Meilleur score: ',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white)),
                                  ElevatedButton(
                                      onPressed: () {
                                        createTimerText();
                                      },
                                      child: Text("Lancer une partie")),
                                ],
                              )
                            : timerText > -1
                                ? Center(
                                    child: Text(
                                      timerText == 4
                                          ? "3"
                                          : timerText == 3
                                              ? "2"
                                              : timerText == 2
                                                  ? "1"
                                                  : timerText == 1
                                                      ? "GO!"
                                                      : "",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  )
                                : Container(),
                      ),
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0)
                ],
              )),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement left direction logic
                    setState(() {
                      resetTimer();
                      gameModel.changeDirection(GameModel.DIRECTION_GAUCHE);
                    });
                  },
                  child: Icon(Icons.arrow_left),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement up direction logic
                        setState(() {
                          resetTimer();
                          gameModel.changeDirection(GameModel.DIRECTION_HAUT);
                        });
                      },
                      child: Icon(Icons.arrow_upward),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement down direction logic
                        setState(() {
                          resetTimer();
                          gameModel.changeDirection(GameModel.DIRECTION_BAS);
                        });
                      },
                      child: Icon(Icons.arrow_downward),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement right direction logic
                    setState(() {
                      resetTimer();
                      gameModel.changeDirection(GameModel.DIRECTION_DROITE);
                    });
                  },
                  child: Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_snake/models/game_model.dart';

class SnakePage extends StatefulWidget {
  const SnakePage({Key? key}) : super(key: key);

  @override
  State<SnakePage> createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  GameModel gameModel = GameModel();
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    print("start");
    gameModel.start();
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        gameModel.moveSnake();
      });
    });
  }

  void resetTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        gameModel.moveSnake();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
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
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Pause',
                child: Text('Pause'),
              ),
              const PopupMenuItem<String>(
                value: 'Replay',
                child: Text('Replay'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.green,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10, // Change this number as per your need
                ),
                itemBuilder: (BuildContext context, int index) {
                  int y = index ~/ GameModel.NB_COLONNES;
                  int x = index - ((index ~/ GameModel.NB_COLONNES) * GameModel.NB_COLONNES);

                  Color cellColor;

                  switch (gameModel.grid[y][x]) {
                    case GameModel.SNAKE_HEAD:
                      cellColor = Colors.yellow;
                      break;
                    case GameModel.SNAKE_BODY:
                      cellColor = Colors.green;
                      break;
                    case GameModel.FOOD:
                      print(index.toString() + " " + x.toString() + " " + y.toString());
                      cellColor = Colors.red;
                      break;
                    default:
                      cellColor = Colors.lightGreen;
                  }

                  return GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        border: Border.all(color: Colors.white),
                      ),
                      // TODO: Add your game cell here
                    ),
                  );
                },
                itemCount:
                    GameModel.NB_CASES, // Change this number as per your need
              ),
            ),
          ),
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

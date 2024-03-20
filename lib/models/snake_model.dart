import 'package:flutter_snake/models/game_model.dart';

class SnakeModel {
  int x;
  int y;
  int size = 1;
  GameModel gameModel;
  List<List<int>> bodyPositions = [];

  SnakeModel({required this.gameModel, this.x = 0, this.y = 0});

  void reset() {
    x = GameModel.NB_COLONNES ~/ 2;
    y = GameModel.NB_LIGNES ~/ 2;
    size = 2;
    bodyPositions = [
      [x, y],
      [y, x - 1]
    ];
    displaySnake();
  }

  void displaySnake() {
    bodyPositions.insert(0, [x, y]);
    gameModel.grid[y][x] = GameModel.SNAKE_HEAD;
    for (int i = 1; i < bodyPositions.length; i++) {
      gameModel.grid[bodyPositions[i][1]][bodyPositions[i][0]] =
          GameModel.SNAKE_HEAD;
    }
    print("new snake head: x: $x, y: $y");
    print("new snake body: x: ${bodyPositions}");
  }

  void moveSnake(int direction) {
    int newX = x;
    int newY = y;

    switch (direction) {
      case GameModel.DIRECTION_HAUT:
        newY--;
        break;
      case GameModel.DIRECTION_DROITE:
        newX++;
        break;
      case GameModel.DIRECTION_BAS:
        newY++;
        break;
      case GameModel.DIRECTION_GAUCHE:
        newX--;
        break;
    }

    if (!gameModel.isInGrid(newX, newY)) {
      return;
    }

    gameModel.grid[y][x] = 0;
    x = newX;
    y = newY;

    bool ateFood = gameModel.isFood(x, y);
    if (ateFood) {
      growSnake();
      gameModel.increaseScore();
      gameModel.foodModel.createFood();
    } else if (bodyPositions.isNotEmpty && bodyPositions.length > size) {
      List<int> lastBodyPart = bodyPositions.removeLast();
      gameModel.grid[lastBodyPart[1]][lastBodyPart[0]] = 0;
    }

    displaySnake();
  }

  void growSnake() {
    size++;
  }
}

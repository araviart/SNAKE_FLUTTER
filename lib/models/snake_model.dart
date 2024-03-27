import 'package:flutter_snake/models/game_model.dart';

class SnakeModel {
  int x;
  int y;
  int size = 1;
  GameModel gameModel;
  List<List<int>> bodyPositions = [];

  SnakeModel({required this.gameModel, this.x = (GameModel.NB_COLONNES ~/ 2) - 3, this.y = GameModel.NB_LIGNES ~/ 2});

  void reset() {
    x = (GameModel.NB_COLONNES ~/ 2) - 3;
    y = GameModel.NB_LIGNES ~/ 2;
    bodyPositions = [];
    size = 1;
  }

  void displaySnake() {
    bodyPositions.insert(0, [x, y]);
    gameModel.grid[y][x] = GameModel.SNAKE_HEAD;
    for (int i = 1; i < bodyPositions.length; i++) {
      gameModel.grid[bodyPositions[i][1]][bodyPositions[i][0]] =
          GameModel.SNAKE_BODY;
    }
    print("new snake head: x: $x, y: $y");
    print("new snake body: x: ${bodyPositions}");
  }

  bool moveSnake(int direction, int oldDirection) {
    int newX = x;
    int newY = y;
    int oldX = x;
    int oldY = y;

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
      gameModel.isGameRunning = false;
      return true;
    }

    if (bodyPositions.isNotEmpty && bodyPositions.length > 1) {
      if (newX == bodyPositions[1][0] && newY == bodyPositions[1][1]) {
          gameModel.changeDirection(oldDirection);
          return false;
      }
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

    // on regarde s'il y a une position présente plus qu'une fois dans la liste

    for (var position in bodyPositions) {
      if (position[0] == x && position[1] == y) {
        // je veux reset la position qu'on vient de mettre
        x = oldX;
        y = oldY;
        displaySnake();
        gameModel.grid[y][x] = GameModel.SNAKE_HEAD;
        gameModel.isGameRunning = false;
        return true;
      }
    }

    displaySnake();
    return false;
  }

  void growSnake() {
    size++;
  }
}

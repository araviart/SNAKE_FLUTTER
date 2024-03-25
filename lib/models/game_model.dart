import 'dart:math';

import 'package:flutter_snake/models/food_model.dart';
import 'package:flutter_snake/models/snake_model.dart';

class GameModel {
  static const int NB_CASES = 140;
  static const int NB_LIGNES = 14;
  static const int NB_COLONNES = 10;

  static const int DIRECTION_HAUT = 0;
  static const int DIRECTION_DROITE = 1;
  static const int DIRECTION_BAS = 2;
  static const int DIRECTION_GAUCHE = 3;

  static const int SNAKE_HEAD = 1;
  static const int SNAKE_BODY = 2;
  static const int FOOD = 3;

  int score = 0;
  int currentDirection = DIRECTION_DROITE;

  List<List<int>> grid =
      List.generate(NB_LIGNES, (i) => List.filled(NB_COLONNES, 0));

  late FoodModel foodModel;
  late SnakeModel snakeModel;

  GameModel() {
    foodModel = FoodModel(gameModel: this);
    snakeModel = SnakeModel(gameModel: this);
  }
  // Add your class properties and methods here

  void start() {
    // on réinitialise la matrice
    for (int i = 0; i < NB_LIGNES; i++) {
      for (int j = 0; j < NB_COLONNES; j++) {
        grid[i][j] = 0;
      }
    }
    foodModel.createFood();
    _displaySnakeBody();
  }

  static List<int> getRandomCoordinates() {
    Random random = Random();
    int randomX = random.nextInt(NB_COLONNES);
    int randomY = random.nextInt(NB_LIGNES);
    print("randomX: $randomX, randomY: $randomY");
    return [randomX, randomY];
  }

  void changeDirection(int newDirection) {
    currentDirection = newDirection;
    moveSnake();
  }

  void moveSnake() {
    snakeModel.moveSnake(currentDirection);
  }

  bool isFood(int x, int y) {
    return grid[y][x] == FOOD;
  }

  bool isInGrid(int x, int y) {
    return x >= 0 && x < NB_COLONNES && y >= 0 && y < NB_LIGNES;
  }

  void increaseScore() {
    score++;
  }

  void _displaySnakeBody() {
    if (snakeModel.bodyPositions.isNotEmpty) {
      for (var position in snakeModel.bodyPositions) {
        int y = position[0];
        int x = position[1];
        grid[y][x] = GameModel.SNAKE_BODY;
      }
      var head = snakeModel.bodyPositions.first;
      grid[head[0]][head[1]] = GameModel.SNAKE_HEAD;
    }
  }

  void eatFood() {}
}

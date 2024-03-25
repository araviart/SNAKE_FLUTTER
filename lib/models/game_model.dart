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
  int oldDirection = DIRECTION_DROITE;

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
    score = 0;
    currentDirection = DIRECTION_DROITE;
    // on réinitialise la matrice
    for (int i = 0; i < NB_LIGNES; i++) {
      for (int j = 0; j < NB_COLONNES; j++) {
        grid[i][j] = 0;
      }
    }
    foodModel.createFood();
    snakeModel.reset();
    snakeModel.displaySnake();
  }

  static List<int> getRandomCoordinates() {
    Random random = Random();
    int randomX = random.nextInt(NB_COLONNES);
    int randomY = random.nextInt(NB_LIGNES);
    print("randomX: $randomX, randomY: $randomY");
    return [randomX, randomY];
  }

  void changeDirection(int newDirection) {
    oldDirection = currentDirection;
    currentDirection = newDirection;
    moveSnake();
  }

  bool moveSnake() {
    return snakeModel.moveSnake(currentDirection, oldDirection);
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
}

import 'package:flutter_snake/models/game_model.dart';

class SnakeModel{
  int x;
  int y;
  int size = 1;
  GameModel gameModel;

  SnakeModel({required this.gameModel, this.x = 0, this.y = 0});

  void reset(){
    x = GameModel.NB_COLONNES ~/ 2;
    y = GameModel.NB_LIGNES ~/ 2;
    size = 2;
    displaySnake();
  }

  void displaySnake(){
    if (gameModel.isFood(x, y)){
      growSnake();
      gameModel.increaseScore();
      gameModel.foodModel.createFood();
    }
    gameModel.grid[y][x] = GameModel.SNAKE_HEAD;
    print("new snake head: x: $x, y: $y");
  }

  void moveSnake(int direction){

    switch(direction){
      case GameModel.DIRECTION_HAUT:
        if (gameModel.isInGrid(x, y-1)){
          gameModel.grid[y][x] = 0;
          y--;
        }
        break;
      case GameModel.DIRECTION_DROITE:
        if (gameModel.isInGrid(x+1, y)){
          gameModel.grid[y][x] = 0;
          x++;
        }
        break;
      case GameModel.DIRECTION_BAS:
        if (gameModel.isInGrid(x, y+1)){
          gameModel.grid[y][x] = 0;
          y++;
        }
        break;
      case GameModel.DIRECTION_GAUCHE:
        if (gameModel.isInGrid(x-1, y)){
          gameModel.grid[y][x] = 0;
          x--;
        }
        break;
    }

    displaySnake();
  }

  void growSnake(){
    size++;
  }
}
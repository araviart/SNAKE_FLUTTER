import 'dart:ffi';

import 'package:flutter_snake/models/game_model.dart';

class FoodModel{

  GameModel gameModel;

  FoodModel({required this.gameModel});


  void createFood(){
    List<int> coordinates = GameModel.getRandomCoordinates();
    gameModel.grid[coordinates[1]][coordinates[0]] = GameModel.FOOD;
  }
}
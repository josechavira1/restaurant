import 'package:flutter/material.dart';

class FoodModel {
  String name;
  String iconPath;
  Color boxColor;
  String description;

  FoodModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
    required this.description,
  });

  static List<FoodModel> getFoods() {
    List<FoodModel> foods = [];

    foods.add(
      FoodModel(name: 'Cheeseburger', iconPath: 'assets/icons/school-solid.svg', boxColor: Colors.blue, description: 'Cheese')
    );
    foods.add(
      FoodModel(name: 'Bacon', iconPath: 'assets/icons/hospital-solid.svg', boxColor: Colors.green, description: 'Bacon and onions')
    );
    foods.add(
      FoodModel(name: 'My melody', iconPath: 'assets/icons/school-solid.svg', boxColor: Colors.blue, description: 'Pink burger')
    );
    foods.add(
      FoodModel(name: 'Kuromi', iconPath: 'assets/icons/hospital-solid.svg', boxColor: Colors.green, description: 'Blac burger')
    );
foods.add(
      FoodModel(name: 'Cheeseburger', iconPath: 'assets/icons/school-solid.svg', boxColor: Colors.blue, description: 'Cheese')
    );
    foods.add(
      FoodModel(name: 'Bacon', iconPath: 'assets/icons/hospital-solid.svg', boxColor: Colors.green, description: 'Bacon and onions')
    );
    foods.add(
      FoodModel(name: 'My melody', iconPath: 'assets/icons/school-solid.svg', boxColor: Colors.blue, description: 'Pink burger')
    );
    foods.add(
      FoodModel(name: 'Kuromi', iconPath: 'assets/icons/hospital-solid.svg', boxColor: Colors.green, description: 'Blac burger')
    );
    return foods;
  }
}
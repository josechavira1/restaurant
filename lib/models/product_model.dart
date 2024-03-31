import 'dart:ffi';

import 'package:flutter/material.dart';

class ProductModel {
  String? id;
  String name;
  double price;
  String? description;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

}
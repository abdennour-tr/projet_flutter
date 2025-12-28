import 'package:flutter/material.dart';
import 'city_model.dart';

class AppCategory {
  final String title;
  final IconData icon;
  final String image;
  final PlaceCategory category;

  const AppCategory({
    required this.title,
    required this.icon,
    required this.image,
    required this.category,
  });
}

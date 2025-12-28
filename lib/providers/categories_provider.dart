import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/city_model.dart';

class CategoriesProvider extends ChangeNotifier {
  final List<AppCategory> _categories = const [
    AppCategory(
      title: "Beach",
      icon: Icons.beach_access,
      image: "assets/categories/beach.jpg",
      category: PlaceCategory.beach,
    ),
    AppCategory(
      title: "Mountain",
      icon: Icons.terrain,
      image: "assets/categories/mountain.webp",
      category: PlaceCategory.mountain,
    ),
    AppCategory(
      title: "City",
      icon: Icons.location_city,
      image: "assets/cities/chefchaouen2.jpg",
      category: PlaceCategory.city,
    ),
    AppCategory(
      title: "Nature",
      icon: Icons.park,
      image: "assets/categories/nature.jpg",
      category: PlaceCategory.nature,
    ),
    AppCategory(
      title: "Monument",
      icon: Icons.account_balance,
      image: "assets/categories/monument.png",
      category: PlaceCategory.monument,
    ),
  ];

  List<AppCategory> get categories => _categories;
}

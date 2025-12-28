import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../services/cities_service.dart';

class CitiesProvider extends ChangeNotifier {
  List<Place> _cities = [];
  bool _loading = false;

  List<Place> get cities => _cities;
  bool get isLoading => _loading;

  Future<void> loadCities() async {
    if (_cities.isNotEmpty) return;

    _loading = true;
    notifyListeners();

    _cities = await CitiesService.loadCities();

    _loading = false;
    notifyListeners();
  }

  List<Place> byCategory(String category) {
    return _cities.where((c) => c.category == category).toList();
  }

  List<Place> search(String query) {
    return _cities
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

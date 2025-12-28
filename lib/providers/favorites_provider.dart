import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city_model.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _storageKey = 'favorite_place_ids';

  final List<Place> _favorites = [];
  List<Place> get favorites => _favorites;

  // ================= INIT =================
  Future<void> loadFavorites(List<Place> allPlaces) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_storageKey) ?? [];

    _favorites.clear();
    _favorites.addAll(
      allPlaces.where((p) => ids.contains(p.id)),
    );

    notifyListeners();
  }

  // ================= CHECK =================
  bool isFavorite(Place place) {
    return _favorites.any((p) => p.id == place.id);
  }

  // ================= TOGGLE =================
  Future<void> toggleFavorite(Place place) async {
    if (isFavorite(place)) {
      _favorites.removeWhere((p) => p.id == place.id);
    } else {
      _favorites.add(place);
    }

    await _save();
    notifyListeners();
  }

  // ================= SAVE =================
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _favorites.map((p) => p.id).toList();
    await prefs.setStringList(_storageKey, ids);
  }
}

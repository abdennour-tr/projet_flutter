import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/city_model.dart';

class CitiesService {
  static Future<List<Place>> loadCities() async {
    final jsonString = await rootBundle.loadString('assets/data/cities.json');

    final data = json.decode(jsonString);

    return (data['cities'] as List).map((e) => Place.fromJson(e)).toList();
  }
}

import 'package:latlong2/latlong.dart';

enum PlaceCategory { city, beach, mountain, nature, monument }

PlaceCategory categoryFromString(String value) {
  return PlaceCategory.values.firstWhere(
    (e) => e.name == value,
  );
}

class NearbyPlace {
  final String name;
  final LatLng position;

  NearbyPlace({
    required this.name,
    required this.position,
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    return NearbyPlace(
      name: json['name'],
      position: LatLng(
        json['position']['lat'],
        json['position']['lng'],
      ),
    );
  }
}

class Place {
  final String id;
  final String name;
  final LatLng position; // ✅ REAJOUTÉ
  final String description;
  final List<String> images;
  final double rating;
  final PlaceCategory category;
  final List<NearbyPlace> nearbyPlaces;

  Place({
    required this.id,
    required this.name,
    required this.position,
    required this.description,
    required this.images,
    required this.rating,
    required this.category,
    required this.nearbyPlaces,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      position: LatLng(
        json['position']['lat'],
        json['position']['lng'],
      ),
      description: json['description'],
      images: List<String>.from(json['images']),
      rating: (json['rating'] as num).toDouble(),
      category: categoryFromString(json['category']),
      nearbyPlaces: (json['nearbyPlaces'] as List)
          .map((e) => NearbyPlace.fromJson(e))
          .toList(),
    );
  }
}

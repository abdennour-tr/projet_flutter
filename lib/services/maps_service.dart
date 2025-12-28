import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteResult {
  final List<LatLng> polyline;
  final double distanceKm;
  final double durationMin;

  RouteResult({
    required this.polyline,
    required this.distanceKm,
    required this.durationMin,
  });
}

class MapsService {
  /// =======================
  /// DISTANCE VOL D’OISEAU (optionnelle)
  /// =======================
  static double calculateAirDistance(LatLng from, LatLng to) {
    return Distance().as(LengthUnit.Kilometer, from, to);
  }

  /// =======================
  /// OUVRIR GOOGLE MAPS
  /// =======================
  static Future<void> openGoogleMaps(
    LatLng from,
    LatLng to,
  ) async {
    final url = "https://www.google.com/maps/dir/?api=1"
        "&origin=${from.latitude},${from.longitude}"
        "&destination=${to.latitude},${to.longitude}";
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  /// =======================
  /// ROUTE OSRM (distance réelle)
  /// =======================
  static Future<RouteResult> getRoute(
    LatLng from,
    LatLng to,
  ) async {
    final url = "https://router.project-osrm.org/route/v1/driving/"
        "${from.longitude},${from.latitude};"
        "${to.longitude},${to.latitude}"
        "?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Erreur OSRM");
    }

    final data = json.decode(response.body);

    final route = data['routes'][0];

    /// Distance en mètres → KM
    final distanceKm = (route['distance'] as num) / 1000;

    /// Durée en secondes → minutes
    final durationMin = (route['duration'] as num) / 60;

    final coords = route['geometry']['coordinates'] as List;

    final polyline =
        coords.map((c) => LatLng(c[1] as double, c[0] as double)).toList();

    return RouteResult(
      polyline: polyline,
      distanceKm: distanceKm,
      durationMin: durationMin,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/city_model.dart';
import '../services/cities_service.dart';
import '../services/maps_service.dart';
import '../providers/location_provider.dart';
import 'place_details_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;

  LatLng _mapCenter = const LatLng(31.7917, -7.0926);
  double _currentZoom = 6;

  bool _didInitialFit = false;

  List<LatLng> route = [];
  double? distance;
  double? duration;

  /// ✅ LISTE DES VILLES CHARGÉES DU JSON
  List<Place> cities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );

    _loadCities();
  }

  /// ================= LOAD CITIES =================
  Future<void> _loadCities() async {
    final loadedCities = await CitiesService.loadCities();

    setState(() {
      cities = loadedCities;
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fitToAllMarkers();
    });
  }

  void _fitToAllMarkers({LatLng? userPosition}) {
    if (cities.isEmpty) return;

    final points = <LatLng>[
      ...cities.map((c) => c.position),
      if (userPosition != null) userPosition,
    ];

    final bounds = LatLngBounds.fromPoints(points);
    _animatedMapController.mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(40, 120, 40, 220),
      ),
    );
  }

  /// ================= ROUTE =================
  Future<void> _drawRouteToCity(
    LatLng userPosition,
    Place city,
  ) async {
    final result = await MapsService.getRoute(
      userPosition,
      city.position,
    );

    setState(() {
      route = result.polyline;
      distance = result.distanceKm;
      duration = result.durationMin;
    });
  }

  /// ================= ZOOM =================
  void _zoomIn() {
    _currentZoom++;
    _animatedMapController.animateTo(zoom: _currentZoom);
  }

  void _zoomOut() {
    _currentZoom--;
    _animatedMapController.animateTo(zoom: _currentZoom);
  }

  void _centerOnUser(LatLng userPosition) {
    _mapCenter = userPosition;
    _animatedMapController.animateTo(
      dest: userPosition,
      zoom: _currentZoom,
    );
  }

  /// ================= BOTTOM SHEET =================
  void _showCityBottomSheet(
    BuildContext context,
    Place city,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  city.images.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                city.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (distance != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "${distance!.toStringAsFixed(1)} km • ${duration!.toStringAsFixed(0)} min",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                city.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Voir détails"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsPage(place: city),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPosition = context.watch<LocationProvider>().userPosition;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_didInitialFit) {
      _didInitialFit = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _fitToAllMarkers(userPosition: userPosition);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte interactive"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed:
                userPosition == null ? null : () => _centerOnUser(userPosition),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _animatedMapController.mapController,
            options: MapOptions(
              initialCenter: userPosition ?? _mapCenter,
              initialZoom: _currentZoom,
              onPositionChanged: (pos, _) {
                _mapCenter = pos.center;
                _currentZoom = pos.zoom;
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              if (route.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route,
                      strokeWidth: 4,
                      color: Colors.green,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (userPosition != null)
                    Marker(
                      point: userPosition,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ...cities.map((city) {
                    return Marker(
                      point: city.position,
                      width: 46,
                      height: 46,
                      child: GestureDetector(
                        onTap: () async {
                          if (userPosition != null) {
                            await _drawRouteToCity(userPosition, city);
                          } else {
                            setState(() {
                              route = [];
                              distance = null;
                              duration = null;
                            });
                          }
                          _showCityBottomSheet(context, city);
                        },
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red.shade600,
                          size: 30,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          Positioned(
            right: 14,
            bottom: 120,
            child: Column(
              children: [
                _mapButton(Icons.add, _zoomIn),
                _mapButton(Icons.remove, _zoomOut),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.green),
        onPressed: onTap,
      ),
    );
  }
}

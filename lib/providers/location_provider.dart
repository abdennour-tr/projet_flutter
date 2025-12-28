import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _userPosition;

  LatLng? get userPosition => _userPosition;

  void setPosition(LatLng position) {
    _userPosition = position;
    notifyListeners();
  }
}

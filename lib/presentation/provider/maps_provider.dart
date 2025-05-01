import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsProvider extends ChangeNotifier {
  LatLng? _currentLocation;
  bool _isLocationPermissionGranted = false;
  bool _isGpsEnabled = false;
  bool _isLoading = true;
  LatLng? _selectedPosition;

  LatLng? get currentLocation => _currentLocation;
  bool get isLocationPermissionGranted => _isLocationPermissionGranted;
  bool get isGpsEnabled => _isGpsEnabled;
  bool get isLoading => _isLoading;
  LatLng? get selectedPosition => _selectedPosition;

  set selectedPosition(LatLng? value) {
    _selectedPosition = value;
    notifyListeners();
  }

  set currentLocation(LatLng? value) {
    _currentLocation = value;
    notifyListeners();
  }

  set isLocationPermissionGranted(bool value) {
    _isLocationPermissionGranted = value;
    notifyListeners();
  }

  set isGpsEnabled(bool value) {
    _isGpsEnabled = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateSelectedPosition(LatLng position) {
    _selectedPosition = position;
    notifyListeners();
  }

  void finalizeSelectedPosition() {
    _currentLocation = _selectedPosition;
    notifyListeners();
  }

  void resetSelectedPosition() {
    _selectedPosition = null;
    _currentLocation = null;
    notifyListeners();
  }
}

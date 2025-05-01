import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/state/add_story_state.dart';

class AddStoryProvider with ChangeNotifier {
  AddStoryState _state = AddStoryInitial();
  final StoryService _storyService;
  final SharedPreferenceService _sharedPreferenceService;
  String? _description;
  List<int>? _imageData;
  String? _filename;
  double? _latitude;
  double? _longitude;
  XFile? _selectedImage;
  bool _isButtonActive = false;
  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  set mapController(GoogleMapController? value) {
    _mapController = value;
    notifyListeners();
  }

  bool get isButtonActive => _isButtonActive;

  bool _isLocationEnabled = false;
  bool get isLocationEnabled => _isLocationEnabled;

  set isLocationEnabled(bool value) {
    _isLocationEnabled = value;
    notifyListeners();
  }

  set isButtonActive(bool value) {
    _isButtonActive = value;
    notifyListeners();
  }

  AddStoryState get state => _state;

  String? get description => _description;
  set description(String? value) {
    _description = value;
    notifyListeners();
  }

  List<int>? get imageData => _imageData;
  set imageData(List<int>? value) {
    _imageData = value;
    notifyListeners();
  }

  String? get filename => _filename;
  set filename(String? value) {
    _filename = value;
    notifyListeners();
  }

  double? get latitude => _latitude;
  set latitude(double? value) {
    _latitude = value;
    notifyListeners();
  }

  double? get longitude => _longitude;
  set longitude(double? value) {
    _longitude = value;
    notifyListeners();
  }

  XFile? get selectedImage => _selectedImage;
  set selectedImage(XFile? value) {
    _selectedImage = value;
    notifyListeners();
  }

  AddStoryProvider(
      {required StoryService storyService,
      required SharedPreferenceService sharedPreferenceService})
      : _storyService = storyService,
        _sharedPreferenceService = sharedPreferenceService;

  Future<void> addStory() async {
    try {
      _state = AddStoryLoading();
      notifyListeners();
      final token = await _sharedPreferenceService.getToken();
      if (token == null || token == "") {
        _state = AddStoryError(
            "You have not logged in yet, hence you are not allowed to post story.");
        notifyListeners();
        return;
      }
      final response = await _storyService.addNewStory(_description.toString(),
          _imageData as List<int>, filename.toString(), token.toString(),
          latitude: latitude, longitude: longitude);
      if (response.error != null && response.error as bool) {
        _state = AddStoryError(response.message.toString());
      } else {
        _state = AddStorySuccess(response);
      }
      notifyListeners();
    } on SocketException catch (e) {
      _state = AddStoryError(e.message);
      notifyListeners();
    } catch (e) {
      _state = AddStoryError(e.toString());
      notifyListeners();
    }
  }

  void resetLocation() {
    _latitude = null;
    _longitude = null;
    _isLocationEnabled = false;
    notifyListeners();
  }

  void setLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    _isLocationEnabled = true;
    notifyListeners();
  }
}

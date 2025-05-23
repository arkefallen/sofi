import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/state/detail_story_state.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailStoryProvider with ChangeNotifier {
  final SharedPreferenceService _sharedPreferenceService;
  DetailStoryState _state = DetailStoryInitial();
  final StoryService _storyService;

  DetailStoryState get state => _state;

  DetailStoryProvider(
      {required StoryService storyService,
      required SharedPreferenceService sharedPreferenceService})
      : _sharedPreferenceService = sharedPreferenceService,
        _storyService = storyService;

  Future<void> fetchDetailStory(String storyId) async {
    try {
      _state = DetailStoryLoading();
      notifyListeners();
      final token = await _sharedPreferenceService.getToken();
      if (token == null || token == "") {
        _state =
            DetailStoryError("User not logged in yet, please login first.");
        notifyListeners();
        return;
      }
      final response =
          await _storyService.getStoryById(token.toString(), storyId);
      if (response.error != null && response.error as bool) {
        _state = DetailStoryError(response.message.toString());
      } else if (response.story == null) {
        _state = DetailStoryError("No story found");
      } else {
        final responseData = response.story!;
        if (responseData.lat != null &&
            responseData.lon != null &&
            responseData.lat != 0 &&
            responseData.lon != 0) {
          final placemarks = await geo.placemarkFromCoordinates(
              responseData.lat!, responseData.lon!);
          var selectedPlacemark = placemarks.first;
          var address =
              "${selectedPlacemark.subLocality}, ${selectedPlacemark.locality}, ${selectedPlacemark.administrativeArea}, ${selectedPlacemark.country}";
          responseData.address = address;
        }
        _state = DetailStorySuccess(responseData);
      }
      notifyListeners();
    } on SocketException catch (e) {
      _state = DetailStoryError(e.message);
      notifyListeners();
    } catch (e) {
      _state = DetailStoryError(e.toString());
      notifyListeners();
    }
  }
}

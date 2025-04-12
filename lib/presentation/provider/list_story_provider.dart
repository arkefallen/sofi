import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/state/list_story_state.dart';

class ListStoryProvider with ChangeNotifier {
  final SharedPreferenceService _sharedPreferenceService;
  ListStoryState _state = ListStoryInitial();
  final StoryService _storyService;

  ListStoryState get state => _state;

  ListStoryProvider({required StoryService storyService, required SharedPreferenceService sharedPreferenceService})
      : _sharedPreferenceService = sharedPreferenceService,
        _storyService = storyService;

  Future<void> fetchListStories() async {
    try {
      _state = ListStoryLoading();
      notifyListeners();
      final token = await _sharedPreferenceService.getToken();
      if (token == null || token == "") {
        _state = ListStoryError("User not logged in yet, please login first.");
        notifyListeners();
        return;
      }
      final response = await _storyService.getListStories(token.toString());
      if (response.error) {
        _state = ListStoryError(response.message.toString());
      } else if (response.listStory == null || response.listStory!.isEmpty) {
        _state = ListStoryError("No stories found");
      } else {
        _state = ListStorySuccess(response.listStory!);
      }
      notifyListeners();
    } on SocketException catch (e) {
      _state = ListStoryError(e.message);
      notifyListeners();
    } catch (e) {
      _state = ListStoryError(e.toString());
      notifyListeners();
    }
  }
}

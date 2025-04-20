import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/state/login_state.dart';

class LoginProvider with ChangeNotifier {
  final SharedPreferenceService _sharedPreferenceService;
  LoginState _state = LoginInitial();
  final StoryService _storyService;

  LoginState get state => _state;

  LoginProvider(
      {required StoryService storyService,
      required SharedPreferenceService sharedPreferenceService})
      : _sharedPreferenceService = sharedPreferenceService,
        _storyService = storyService;

  bool _isPasswordFormObscured = true;
  bool get isPasswordFormObscured => _isPasswordFormObscured;
  void setPasswordFormObscured(bool value) {
    _isPasswordFormObscured = value;
    notifyListeners();
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      _state = LoginLoading();
      notifyListeners();
      final response = await _storyService.login(email, password);
      if (response.error != null && response.error as bool) {
        _state = LoginError(response.message.toString());
      } else if (response.loginResult == null) {
        _state = LoginError("No data found");
      } else {
        _state = LoginSuccess(response.loginResult!.name.toString(),
            response.loginResult!.userId.toString());
        await _sharedPreferenceService
            .saveToken(response.loginResult!.token.toString());
      }
      notifyListeners();
    } on SocketException catch (e) {
      _state = LoginError(e.message);
      notifyListeners();
    } catch (e) {
      _state = LoginError(e.toString());
      notifyListeners();
    }
  }
}

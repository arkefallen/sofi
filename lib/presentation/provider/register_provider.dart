import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/state/register_state.dart';

class RegisterProvider with ChangeNotifier {
  RegisterState _state = RegisterInitial();
  final StoryService _storyService;

  RegisterState get state => _state;

  RegisterProvider({required StoryService storyService})
      : _storyService = storyService;

  bool _isPasswordFormObscured = true;
  bool get isPasswordFormObscured => _isPasswordFormObscured;
    void setPasswordFormObscured(bool value) {
    _isPasswordFormObscured = value;
    notifyListeners();
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      _state = RegisterLoading();
      notifyListeners();
      final response = await _storyService.register(name, email, password);
      if (response.error != null && response.error as bool) {
        _state = RegisterError(response.message.toString());
      } else {
        _state = RegisterSuccess(response);
      }
      notifyListeners();
    } on SocketException catch (e) {
      _state = RegisterError(e.message);
      notifyListeners();
    } catch (e) {
      _state = RegisterError(e.toString());
      notifyListeners();
    }
  }
}

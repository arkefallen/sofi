import 'dart:async';

import 'package:flutter/foundation.dart';

class PageManager extends ChangeNotifier {
  late Completer<String> _registerCompleter;
  late Completer<String> _addStoryCompleter;

  Future<String> waitForRegisterResult() async {
    _registerCompleter = Completer<String>();
    return _registerCompleter.future;
  }

  void returnRegisterResult(String result) {
    if (!_registerCompleter.isCompleted) {
      _registerCompleter.complete(result);
    }
  }

  Future<String> waitForAddStoryResult() async {
    _addStoryCompleter = Completer<String>();
    return _addStoryCompleter.future;
  }

  void returnAddStoryResult(String result) {
    if (!_addStoryCompleter.isCompleted) {
      _addStoryCompleter.complete(result);
    }
  }
}

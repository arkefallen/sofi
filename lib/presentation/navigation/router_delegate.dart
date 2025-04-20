import 'package:flutter/material.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/presentation/screen/add_story_screen.dart';
import 'package:sofi/presentation/screen/detail_story_screen.dart';
import 'package:sofi/presentation/screen/home_screen.dart';
import 'package:sofi/presentation/screen/login_screen.dart';
import 'package:sofi/presentation/screen/register_screen.dart';
import 'package:sofi/presentation/screen/settings_screen.dart';

class SofiRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final SharedPreferenceService _sharedPreferenceService;

  SofiRouterDelegate(
    this._sharedPreferenceService,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _checkLoggedIn();
  }

  _checkLoggedIn() async {
    final token = await _sharedPreferenceService.getToken();
    if (token != null && token.isNotEmpty) {
      isLoggedIn = true;
      notifyListeners();
    } else {
      isLoggedIn = false;
      notifyListeners();
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  List<Page> navStack = [];
  bool isLoggedIn = false;
  bool isRegister = false;
  bool isAddStory = false;
  bool isSettings = false;
  String? selectedStory;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      navStack = _loggedInStack;
    } else {
      navStack = _loggedOutStack;
    }
    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        final key = page.key as ValueKey;
        if (key.value is String &&
            selectedStory != null &&
            key.value.startsWith(selectedStory.toString())) {
          selectedStory = null;
        } else if (key.value == 'AddStoryScreen') {
          isAddStory = false;
        } else if (key.value == 'SettingsScreen') {
          isSettings = false;
        }
        notifyListeners();
      },
    );
  }

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey('LoginScreen'),
          child: LoginScreen(
            toHomeScreen: () {
              isLoggedIn = true;
              notifyListeners();
            },
            toRegisterScreen: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister)
          MaterialPage(
            key: const ValueKey('RegisterScreen'),
            child: RegisterScreen(
              toLoginScreen: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey('HomeScreen'),
          child: HomeScreen(
            toLoginScreen: () {
              isLoggedIn = false;
              notifyListeners();
            },
            toAddStoryScreen: () {
              isAddStory = true;
              notifyListeners();
            },
            toSettingsScreen: () {
              isSettings = true;
              notifyListeners();
            },
            title: 'Sofi',
            toDetailStoryScreen: (storyId) {
              selectedStory = storyId;
              notifyListeners();
            },
          ),
        ),
        if (isAddStory)
          MaterialPage(
            key: const ValueKey('AddStoryScreen'),
            child: AddStoryScreen(
              toHomeScreen: () {
                isAddStory = false;
                notifyListeners();
              },
            ),
          ),
        if (isSettings)
          MaterialPage(
            key: const ValueKey('SettingsScreen'),
            child: SettingsScreen(
              toLoginScreen: () {
                isLoggedIn = false;
                notifyListeners();
                _checkLoggedIn();
              },
            ),
          ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: DetailStoryScreen(
              storyId: selectedStory!,
            ),
          ),
      ];

  @override
  Future<void> setNewRoutePath(configuration) async {}
}

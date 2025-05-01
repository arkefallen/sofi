import 'package:flutter/material.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/presentation/provider/localization_provider.dart';
import 'package:sofi/presentation/screen/add_story_screen.dart';
import 'package:sofi/presentation/screen/detail_story_screen.dart';
import 'package:sofi/presentation/screen/home_screen.dart';
import 'package:sofi/presentation/screen/login_screen.dart';
import 'package:sofi/presentation/screen/maps_screen.dart';
import 'package:sofi/presentation/screen/register_screen.dart';
import 'package:sofi/presentation/screen/settings_screen.dart';
import 'package:sofi/presentation/widget/bottom_sheet_page.dart';
import 'package:sofi/presentation/widget/dialog_page.dart';

class SofiRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final SharedPreferenceService _sharedPreferenceService;
  final LocalizationProvider _localizationProvider;

  SofiRouterDelegate(this._sharedPreferenceService, this._localizationProvider)
      : _navigatorKey = GlobalKey<NavigatorState>() {
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
  bool isMaps = false;
  bool isSettings = false;
  bool isLogoutConfirmation = false;
  bool isChangeLanguage = false;
  String? selectedStory;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      navStack = _loggedInStack(context);
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
        } else if (key.value == 'MapsScreen') {
          isMaps = false;
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

  List<Page> _loggedInStack(BuildContext context) {
    return [
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
            toMapsScreen: () {
              isMaps = true;
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
            onLogoutConfirmation: () {
              isLogoutConfirmation = true;
              notifyListeners();
            },
            onChangeLanguage: () {
              isChangeLanguage = true;
              notifyListeners();
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
      if (isLogoutConfirmation)
        DialogPage(
          key: const ValueKey('LogoutConfirmation'),
          title: AppLocalizations.of(context)!.logout,
          content: AppLocalizations.of(context)!.logoutConfirmation,
          onConfirm: () {
            _sharedPreferenceService.removeAllData();
            isLoggedIn = false;
            isLogoutConfirmation = false;
            notifyListeners();
          },
          onCancel: () {
            isLogoutConfirmation = false;
            notifyListeners();
          },
          confirmText: AppLocalizations.of(context)!.logout,
          cancelText: AppLocalizations.of(context)!.cancel,
        ),
      if (isChangeLanguage)
        BottomSheetPage(
          key: const ValueKey('ChangeLanguage'),
          title: AppLocalizations.of(context)!.selectLanguage,
          content: Column(
            children: AppLocalizations.supportedLocales.map(
              (locale) {
                return ListTile(
                  leading: Text(
                    _localizationProvider.getFlag(locale.languageCode),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  title: locale.languageCode == 'en'
                      ? Text(AppLocalizations.of(context)!.english)
                      : Text(AppLocalizations.of(context)!.bahasa),
                  onTap: () {
                    _localizationProvider.setLocale(locale);
                    isChangeLanguage = false;
                    notifyListeners();
                  },
                );
              },
            ).toList(),
          ),
          onCancel: () {
            isChangeLanguage = false;
            notifyListeners();
          },
        ),
      if (isMaps)
        MaterialPage(
          key: const ValueKey('MapsScreen'),
          child: MapsScreen(
            onLocationFinalized: () {
              isMaps = false;
              notifyListeners();
            },
          ),
        ),
    ];
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}

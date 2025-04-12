import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String _userTokenKey = 'user_token';

  Future<void> saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userTokenKey, value);
  }

  Future<dynamic> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(_userTokenKey) ?? "";
  }

  Future<dynamic> removeAllData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
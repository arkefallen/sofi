import 'dart:io';

import 'package:sofi/data/model/list_story_model.dart';
import 'package:sofi/data/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:sofi/data/model/register_model.dart';

class StoryService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<LoginModel> login(
    String email,
    String password,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'email': email,
          'password': password,
        },
      );
      return LoginModel.fromRawJson(response.body);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<RegisterModel> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return RegisterModel.fromRawJson(response.body);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ListStoryModel> getListStories(String token) async {
    try {
      var response = await http.get(
        Uri.parse('$_baseUrl/stories'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      return ListStoryModel.fromRawJson(response.body);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

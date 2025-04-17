import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sofi/data/model/add_story_model.dart';
import 'package:sofi/data/model/detail_story_model.dart';
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

  Future<DetailStoryModel> getStoryById(String token, String id) async {
    try {
      var response = await http.get(
        Uri.parse('$_baseUrl/stories/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      return DetailStoryModel.fromRawJson(response.body);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AddStoryModel> addNewStory(
    String description,
    List<int> imageData,
    String filename,
    String token, {
    double? latitude,
    double? longitude,
  }) async {
    try {
      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/stories'),
      );
      final http.MultipartFile multiPartFile = http.MultipartFile.fromBytes(
        "photo",
        imageData,
        filename: filename,
      );
      Map<String, String> fields = {
        "description": description,
      };
      final Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      request.fields.addAll(fields);
      request.headers.addAll(headers);
      request.files.add(multiPartFile);
      final http.StreamedResponse streamedResponse = await request.send();
      final Uint8List responseList = await streamedResponse.stream.toBytes();
      final String responseData = String.fromCharCodes(responseList);
      return AddStoryModel.fromRawJson(responseData);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sofi/data/model/add_story_model.dart';
import 'package:sofi/data/model/detail_story_model.dart';
import 'package:sofi/data/model/list_story_model.dart';
import 'package:sofi/data/model/login_model.dart';
import 'package:sofi/data/model/register_model.dart';

class StoryService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';
  final _dioClient = Dio();

  StoryService() {
    if (kDebugMode) {
      _dioClient.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          responseHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Future<LoginModel> login(
    String email,
    String password,
  ) async {
    try {
      var response = await _dioClient.post(
        '$_baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginModel.fromJson(response.data as Map<String, dynamic>);
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
      var response = await _dioClient.post(
        '$_baseUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return RegisterModel.fromJson(response.data as Map<String, dynamic>);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ListStoryModel> getListStories(
    String token, [
    int? page,
    int? size,
  ]) async {
    try {
      final response = await _dioClient.get(
        '$_baseUrl/stories',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        queryParameters: {
          if (page != null) "page": page,
          if (size != null) "size": size,
          "location": "0",
        },
      );
      return ListStoryModel.fromJson(response.data as Map<String, dynamic>);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<DetailStoryModel> getStoryById(String token, String id) async {
    try {
      var response = await _dioClient.get(
        '$_baseUrl/stories/$id',
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );
      return DetailStoryModel.fromJson(response.data as Map<String, dynamic>);
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
      final formData = FormData.fromMap({
        "photo": MultipartFile.fromBytes(
          imageData,
          filename: filename,
        ),
        "description": description,
        if (latitude != null) "lat": latitude.toString(),
        if (longitude != null) "lon": longitude.toString(),
      });

      final response = await _dioClient.post(
        '$_baseUrl/stories',
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      return AddStoryModel.fromJson(response.data as Map<String, dynamic>);
    } on SocketException catch (_) {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

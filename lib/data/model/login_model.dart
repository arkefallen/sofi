import 'dart:convert';
import 'package:sofi/data/model/general_model.dart';
import 'package:sofi/data/model/login_result_model.dart';

class LoginModel extends GeneralModel{

  LoginResultModel? loginResult;

  LoginModel({
    required super.error,
    required super.message,
    this.loginResult,
  });

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        error: json["error"],
        message: json["message"],
        loginResult: json["loginResult"] == null
            ? null
            : LoginResultModel.fromJson(json["loginResult"]),
      );
}

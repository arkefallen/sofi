import 'dart:convert';

class RegisterModel {
  bool? error;
  String? message;

  RegisterModel({
    this.error,
    this.message,
  });

  factory RegisterModel.fromRawJson(String str) =>
      RegisterModel.fromJson(json.decode(str));

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        error: json["error"],
        message: json["message"],
      );
}

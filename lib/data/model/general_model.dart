import 'dart:convert';

class GeneralModel {
  bool? error;
  String? message;

  GeneralModel({
    this.error,
    this.message,
  });

  factory GeneralModel.fromRawJson(String str) =>
      GeneralModel.fromJson(json.decode(str));

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
        error: json["error"],
        message: json["message"],
      );
}
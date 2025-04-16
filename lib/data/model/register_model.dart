import 'dart:convert';

import 'package:sofi/data/model/general_model.dart';

class RegisterModel extends GeneralModel {
  RegisterModel({
    required super.error,
    required super.message,
  });

  factory RegisterModel.fromRawJson(String str) =>
      RegisterModel.fromJson(json.decode(str));

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        error: json["error"],
        message: json["message"],
      );
}

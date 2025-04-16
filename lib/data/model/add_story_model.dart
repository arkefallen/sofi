import 'dart:convert';

import 'package:sofi/data/model/general_model.dart';

class AddStoryModel extends GeneralModel {
  AddStoryModel({
    required super.error,
    required super.message,
  });

  factory AddStoryModel.fromRawJson(String str) =>
      AddStoryModel.fromJson(json.decode(str));

  factory AddStoryModel.fromJson(Map<String, dynamic> json) => AddStoryModel(
        error: json["error"],
        message: json["message"],
      );
}

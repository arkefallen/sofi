import 'package:json_annotation/json_annotation.dart';

part 'general_model.g.dart';

@JsonSerializable()
class GeneralModel {
  bool? error;
  String? message;

  GeneralModel({
    this.error,
    this.message,
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) => _$GeneralModelFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:sofi/data/model/general_model.dart';

part 'register_model.g.dart';

@JsonSerializable()
class RegisterModel extends GeneralModel {
  RegisterModel({
    required super.error,
    required super.message,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => _$RegisterModelFromJson(json);
}

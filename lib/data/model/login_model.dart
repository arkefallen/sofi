import 'package:json_annotation/json_annotation.dart';
import 'package:sofi/data/model/general_model.dart';
import 'package:sofi/data/model/login_result_model.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel extends GeneralModel{
  @JsonKey(name: "loginResult")
  LoginResultModel? loginResult;

  LoginModel({
    required super.error,
    required super.message,
    this.loginResult,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);
}

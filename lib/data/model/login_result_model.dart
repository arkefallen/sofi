
import 'package:json_annotation/json_annotation.dart';

part 'login_result_model.g.dart';

@JsonSerializable()
class LoginResultModel {
    String? userId;
    String? name;
    String? token;

    LoginResultModel({
        this.userId,
        this.name,
        this.token,
    });

    factory LoginResultModel.fromJson(Map<String, dynamic> json) => _$LoginResultModelFromJson(json);
}

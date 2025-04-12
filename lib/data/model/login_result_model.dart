import 'dart:convert';

class LoginResultModel {
    String? userId;
    String? name;
    String? token;

    LoginResultModel({
        this.userId,
        this.name,
        this.token,
    });

    factory LoginResultModel.fromRawJson(String str) => LoginResultModel.fromJson(json.decode(str));

    factory LoginResultModel.fromJson(Map<String, dynamic> json) => LoginResultModel(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
    );
}

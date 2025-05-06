// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResultModel _$LoginResultModelFromJson(Map<String, dynamic> json) =>
    LoginResultModel(
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$LoginResultModelToJson(LoginResultModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'token': instance.token,
    };

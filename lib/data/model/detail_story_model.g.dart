// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailStoryModel _$DetailStoryModelFromJson(Map<String, dynamic> json) =>
    DetailStoryModel(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      story: json['story'] == null
          ? null
          : StoryModel.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailStoryModelToJson(DetailStoryModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };

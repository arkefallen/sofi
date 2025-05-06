// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStoryModel _$ListStoryModelFromJson(Map<String, dynamic> json) =>
    ListStoryModel(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      listStory: (json['listStory'] as List<dynamic>?)
          ?.map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListStoryModelToJson(ListStoryModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };

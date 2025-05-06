
import 'package:json_annotation/json_annotation.dart';
import 'package:sofi/data/model/general_model.dart';

part 'add_story_model.g.dart';

@JsonSerializable()
class AddStoryModel extends GeneralModel {
  AddStoryModel({
    required super.error,
    required super.message,
  });

  factory AddStoryModel.fromJson(Map<String, dynamic> json) => _$AddStoryModelFromJson(json);
}

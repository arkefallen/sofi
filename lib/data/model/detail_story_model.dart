
import 'package:json_annotation/json_annotation.dart';
import 'package:sofi/data/model/general_model.dart';
import 'package:sofi/data/model/story_model.dart';

part 'detail_story_model.g.dart';

@JsonSerializable()
class DetailStoryModel extends GeneralModel {
    @JsonKey(name: "story")
    StoryModel? story;

    DetailStoryModel({
        required super.error,
        required super.message,
        this.story,
    });

    factory DetailStoryModel.fromJson(Map<String, dynamic> json) => _$DetailStoryModelFromJson(json);
}
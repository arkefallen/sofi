import 'package:json_annotation/json_annotation.dart';
import 'package:sofi/data/model/general_model.dart';
import 'package:sofi/data/model/story_model.dart';

part 'list_story_model.g.dart';

@JsonSerializable()
class ListStoryModel extends GeneralModel {
    @JsonKey(name: "listStory")
    List<StoryModel>? listStory;

    ListStoryModel({
        required super.error,
        required super.message,
        this.listStory,
    });

    factory ListStoryModel.fromJson(Map<String, dynamic> json) => _$ListStoryModelFromJson(json);

}
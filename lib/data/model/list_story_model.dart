import 'package:sofi/data/model/general_model.dart';
import 'package:sofi/data/model/story_model.dart';

class ListStoryModel extends GeneralModel {
    List<StoryModel>? listStory;

    ListStoryModel({
        required super.error,
        required super.message,
        this.listStory,
    });

    factory ListStoryModel.fromJson(Map<String, dynamic> json) => ListStoryModel(
        error: json["error"],
        message: json["message"],
        listStory: List<StoryModel>.from(json["listStory"].map((x) => StoryModel.fromJson(x))),
    );

}
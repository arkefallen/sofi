import 'dart:convert';

import 'package:sofi/data/model/general_model.dart';
import 'package:sofi/data/model/story_model.dart';

class DetailStoryModel extends GeneralModel {
    StoryModel? story;

    DetailStoryModel({
        required super.error,
        required super.message,
        this.story,
    });

    factory DetailStoryModel.fromRawJson(String str) => DetailStoryModel.fromJson(json.decode(str));

    factory DetailStoryModel.fromJson(Map<String, dynamic> json) => DetailStoryModel(
        error: json["error"],
        message: json["message"],
        story: json["story"] == null ? null : StoryModel.fromJson(json["story"]),
    );
}
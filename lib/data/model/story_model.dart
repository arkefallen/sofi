
import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "photoUrl")
  String? photoUrl;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "lat")
  double? lat;
  @JsonKey(name: "lon")
  double? lon;
  String? address;

  StoryModel({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
    this.address,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
}

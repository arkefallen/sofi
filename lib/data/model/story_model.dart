import 'dart:convert';

class StoryModel {
    final String id;
    final String name;
    final String description;
    final String photoUrl;
    final DateTime createdAt;
    final double lat;
    final double lon;

    StoryModel({
        required this.id,
        required this.name,
        required this.description,
        required this.photoUrl,
        required this.createdAt,
        required this.lat,
        required this.lon,
    });

    factory StoryModel.fromRawJson(String str) => StoryModel.fromJson(json.decode(str));

    factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
    );
}
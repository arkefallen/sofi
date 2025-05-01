
import 'package:sofi/data/model/general_model.dart';

class AddStoryModel extends GeneralModel {
  AddStoryModel({
    required super.error,
    required super.message,
  });

  factory AddStoryModel.fromJson(Map<String, dynamic> json) => AddStoryModel(
        error: json["error"],
        message: json["message"],
      );
}

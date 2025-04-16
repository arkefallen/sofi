import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sofi/data/model/story_model.dart';

@immutable
abstract class DetailStoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailStoryInitial extends DetailStoryState {}

class DetailStoryLoading extends DetailStoryState {}

class DetailStorySuccess extends DetailStoryState {
  final StoryModel data;

  DetailStorySuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class DetailStoryError extends DetailStoryState {
  final String message;

  DetailStoryError(this.message);

  @override
  List<Object?> get props => [message];
}
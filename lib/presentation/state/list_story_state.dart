import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sofi/data/model/story_model.dart';

@immutable
abstract class ListStoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListStoryInitial extends ListStoryState {}

class ListStoryLoading extends ListStoryState {}

class ListStorySuccess extends ListStoryState {
  final List<StoryModel> stories;

  ListStorySuccess(this.stories);

  @override
  List<Object?> get props => [stories];
}

class ListStoryError extends ListStoryState {
  final String message;

  ListStoryError(this.message);

  @override
  List<Object?> get props => [message];
}
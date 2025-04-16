import 'package:equatable/equatable.dart';
import 'package:sofi/data/model/add_story_model.dart';

abstract class AddStoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddStoryInitial extends AddStoryState {}

class AddStoryLoading extends AddStoryState {}

class AddStorySuccess extends AddStoryState {
  final AddStoryModel data;

  AddStorySuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AddStoryError extends AddStoryState {
  final String message;

  AddStoryError(this.message);

  @override
  List<Object?> get props => [message];
}

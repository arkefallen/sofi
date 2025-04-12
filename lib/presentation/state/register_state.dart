import 'package:equatable/equatable.dart';
import 'package:sofi/data/model/register_model.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterModel data;

  RegisterSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

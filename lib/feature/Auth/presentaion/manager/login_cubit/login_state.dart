import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;
  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class PendingApproval extends LoginState {
  final UserEntity user;
  const PendingApproval(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String errMessage;
  const LoginFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
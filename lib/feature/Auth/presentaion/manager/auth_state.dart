import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterSuccess extends AuthState {
  final String message;
  const RegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String errMessage;
  const AuthFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class PendingApproval extends AuthState {
  final UserEntity user;
  const PendingApproval(this.user);

  @override
  List<Object?> get props => [user];
}

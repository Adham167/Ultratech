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

// =========================================================
// Forgot Password
// =========================================================

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordError extends AuthState {
  final String error;

  const ForgotPasswordError(this.error);

  @override
  List<Object?> get props => [error];
}

class ForgotPasswordFailure extends AuthState {
  final String errMessage;

  const ForgotPasswordFailure(this.errMessage);

  String get error => errMessage;

  @override
  List<Object?> get props => [errMessage];
}

// =========================================================
// Reset Password
// =========================================================

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordError extends AuthState {
  final String error;

  const ResetPasswordError(this.error);

  @override
  List<Object?> get props => [error];
}

// =========================================================
// Change Password
// =========================================================

class ChangePasswordLoading extends AuthState {}

class ChangePasswordSuccess extends AuthState {
  final String message;

  const ChangePasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordError extends AuthState {
  final String error;

  const ChangePasswordError(this.error);

  @override
  List<Object?> get props => [error];
}
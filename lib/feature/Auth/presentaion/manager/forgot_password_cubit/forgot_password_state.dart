import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errMessage;

  const ForgotPasswordFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class ResendOtpLoading extends ForgotPasswordState {}

class ResendOtpSuccess extends ForgotPasswordState {
  final String message;

  const ResendOtpSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResendOtpFailure extends ForgotPasswordState {
  final String errMessage;

  const ResendOtpFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends ForgotPasswordState {
  final String errMessage;

  const ResetPasswordFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

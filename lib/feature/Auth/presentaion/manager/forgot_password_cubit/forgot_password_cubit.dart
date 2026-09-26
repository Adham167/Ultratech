import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/forgot_password_usecase.dart';
import '../../../domain/usecases/reset_password_usecase.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit({
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordInitial());

  Future<void> forgotPassword({
    required String identifier,
  }) async {
    emit(ForgotPasswordLoading());

    final result = await forgotPasswordUseCase(
      identifier: identifier,
    );

    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.errMessage)),
      (message) => emit(ForgotPasswordSuccess(message)),
    );
  }

  Future<void> resendOtp({
    required String identifier,
  }) async {
    emit(ResendOtpLoading());

    final result = await forgotPasswordUseCase(
      identifier: identifier,
    );

    result.fold(
      (failure) => emit(ResendOtpFailure(failure.errMessage)),
      (message) => emit(ResendOtpSuccess(message)),
    );
  }

  Future<void> resetPassword({
    required String emailOrPhone,
    required String code,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    final result = await resetPasswordUseCase(
      emailOrPhone: emailOrPhone,
      code: code,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(ResetPasswordFailure(failure.errMessage)),
      (message) => emit(ResetPasswordSuccess(message)),
    );
  }
}

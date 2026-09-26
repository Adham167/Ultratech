import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/utils/user_role.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final FlutterSecureStorage secureStorage;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.changePasswordUseCase,
    required this.secureStorage,
  }) : super(AuthInitial());

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      phoneNumber: phoneNumber,
      password: password,
    );

    result.fold(
          (failure) => emit(
        AuthFailure(failure.errMessage),
      ),
          (user) async {
        await _saveUserData(user);

        if (user.isApproved) {
          emit(AuthSuccess(user));
        } else {
          emit(PendingApproval(user));
        }
      },
    );
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      role: role.id,
    );

    result.fold(
          (failure) => emit(
        AuthFailure(failure.errMessage),
      ),
          (message) => emit(
        RegisterSuccess(message),
      ),
    );
  }

  Future<void> forgotPassword({
    required String identifier,
  }) async {
    emit(ForgotPasswordLoading());

    final result = await forgotPasswordUseCase(
      identifier: identifier,
    );

    result.fold(
          (failure) => emit(
        ForgotPasswordFailure(
          failure.errMessage,
        ),
      ),
          (message) => emit(
        ForgotPasswordSuccess(message),
      ),
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
          (failure) => emit(
        ResetPasswordError(
          failure.errMessage,
        ),
      ),
          (message) => emit(
        ResetPasswordSuccess(message),
      ),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    final result = await changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.fold(
          (failure) => emit(
        ChangePasswordError(
          failure.errMessage,
        ),
      ),
          (message) => emit(
        ChangePasswordSuccess(message),
      ),
    );
  }

  Future<void> _saveUserData(
      UserEntity user,
      ) async {
    await secureStorage.write(
      key: 'token',
      value: user.token,
    );

    await secureStorage.write(
      key: 'refreshToken',
      value: user.refreshToken,
    );

    await secureStorage.write(
      key: 'role',
      value: user.role.toString(),
    );

    await secureStorage.write(
      key: 'userId',
      value: user.userId.toString(),
    );

    await secureStorage.write(
      key: 'isApproved',
      value: user.isApproved.toString(),
    );

    await secureStorage.write(
      key: 'refreshTokenExpiration',
      value: user.refreshTokenExpiration.toIso8601String(),
    );
  }
}
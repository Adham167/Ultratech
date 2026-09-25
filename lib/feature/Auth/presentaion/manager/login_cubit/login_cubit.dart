import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final FlutterSecureStorage secureStorage;

  LoginCubit({
    required this.loginUseCase,
    required this.secureStorage,
  }) : super(LoginInitial());

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(LoginLoading());
    final result = await loginUseCase(
      phoneNumber: phoneNumber,
      password: password,
    );

    result.fold(
          (failure) => emit(LoginFailure(failure.errMessage)),
          (user) async {
        if (user.isApproved) {
          await _saveUserData(user);
          emit(LoginSuccess(user));
        } else {
          // تجنب حفظ الـ Tokens لحساب Pending
          emit(PendingApproval(user));
        }
      },
    );
  }

  Future<void> _saveUserData(UserEntity user) async {
    await secureStorage.write(key: 'token', value: user.token);
    await secureStorage.write(key: 'refreshToken', value: user.refreshToken);
    await secureStorage.write(key: 'role', value: user.role.toString());
    await secureStorage.write(key: 'userId', value: user.userId.toString());
    await secureStorage.write(key: 'isApproved', value: user.isApproved.toString());
    await secureStorage.write(
      key: 'refreshTokenExpiration',
      value: user.refreshTokenExpiration.toIso8601String(),
    );
  }
}
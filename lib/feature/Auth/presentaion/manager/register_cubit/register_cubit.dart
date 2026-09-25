import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/user_role.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({
    required this.registerUseCase,
  }) : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    emit(RegisterLoading());
    final result = await registerUseCase(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      role: role.id,
    );

    result.fold(
          (failure) => emit(RegisterFailure(failure.errMessage)),
          (message) => emit(RegisterSuccess(message)),
    );
  }
}
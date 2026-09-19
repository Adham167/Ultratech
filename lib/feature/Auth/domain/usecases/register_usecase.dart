import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required int role,
  }) async {
    return await repository.register(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      role: role,
    );
  }
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String phoneNumber,
    required String password,
  }) async {
    return await repository.login(
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}

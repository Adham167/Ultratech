import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String emailOrPhone,
    required String code,
    required String newPassword,
  }) {
    return repository.resetPassword(
      emailOrPhone: emailOrPhone,
      code: code,
      newPassword: newPassword,
    );
  }
}

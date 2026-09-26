import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, String>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required int role,
  });

  Future<Either<Failure, String>> forgotPassword({
    required String identifier,
  });

  Future<Either<Failure, String>> resetPassword({
    required String emailOrPhone,
    required String code,
    required String newPassword,
  });

  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
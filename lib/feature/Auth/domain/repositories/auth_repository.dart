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
}

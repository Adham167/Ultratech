import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        LoginRequestModel(
          phoneNumber: phoneNumber,
          password: password,
        ),
      );

      if (response.succeeded &&
          response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ServerFailure(
            response.errors.isNotEmpty
                ? response.errors.join('\n')
                : response.message,
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return Left(
          ServerFailure.fromDioException(e),
        );
      }

      return Left(
        ServerFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required int role,
  }) async {
    try {
      final response =
      await remoteDataSource.register(
        RegisterRequestModel(
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          role: role,
        ),
      );

      if (response.succeeded) {
        return Right(response.message);
      } else {
        return Left(
          ServerFailure(
            response.errors.isNotEmpty
                ? response.errors.join('\n')
                : response.message,
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return Left(
          ServerFailure.fromDioException(e),
        );
      }

      return Left(
        ServerFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String identifier,
  }) async {
    try {
      final response =
      await remoteDataSource.forgotPassword(
        identifier,
      );

      if (response.succeeded) {
        return Right(response.message);
      }

      return Left(
        ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : response.message,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        return Left(
          ServerFailure.fromDioException(e),
        );
      }

      return Left(
        ServerFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String emailOrPhone,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await remoteDataSource.resetPassword(
        emailOrPhone: emailOrPhone,
        code: code,
        newPassword: newPassword,
      );

      if (response.succeeded) {
        return Right(response.message);
      }

      return Left(
        ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : response.message,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        return Left(
          ServerFailure.fromDioException(e),
        );
      }

      return Left(
        ServerFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (response.succeeded) {
        return Right(response.message);
      }

      return Left(
        ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : response.message,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        return Left(
          ServerFailure.fromDioException(e),
        );
      }

      return Left(
        ServerFailure(e.toString()),
      );
    }
  }
}
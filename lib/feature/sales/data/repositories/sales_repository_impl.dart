import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../technician/data/models/order_model.dart';
import '../../../technician/data/models/product_model.dart';
import '../../domain/entities/agent_entity.dart';
import '../../domain/entities/area_entity.dart';
import '../../domain/entities/customer_check_result_entity.dart';
import '../../domain/entities/maintenance_assigned_entity.dart';
import '../../domain/entities/register_customer_params.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/usecases/submit_maintenance_decision_params.dart';
import '../datasources/sales_remote_data_source.dart';
import '../models/check_phone_response_model.dart';
import '../models/create_order_request_dto.dart';
import '../models/customer_profile_model.dart';
import '../models/maintenance_decision_request_model.dart';
import '../models/register_customer_request_model.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource remoteDataSource;

  SalesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CustomerCheckResultEntity>> checkPhone(String phoneNumber) async {
    try {
      final response = await remoteDataSource.checkPhone(phoneNumber);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckPhoneResponseModel>> checkPhoneDetails(String phoneNumber) async {
    try {
      final response = await remoteDataSource.checkPhoneDetails(phoneNumber);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerProfileModel>> getCustomerProfile(int customerId) async {
    try {
      final response = await remoteDataSource.getCustomerProfile(customerId);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderDetails(int orderId) async {
    try {
      final response = await remoteDataSource.getOrderDetails(orderId);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderRequestDto request) async {
    try {
      final response = await remoteDataSource.createOrder(request);
      if (response.succeeded) {
        return Right(response.data ?? response.message);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final response = await remoteDataSource.getProducts();
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AreaEntity>>> getAreas() async {
    try {
      final response = await remoteDataSource.getAreas();
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerCustomer(RegisterCustomerParams params) async {
    try {
      final response = await remoteDataSource.registerCustomer(
        RegisterCustomerRequestModel(
          fullName: params.fullName,
          phoneNumber: params.phoneNumber,
          address: params.address,
          areaId: params.areaId,
        ),
      );
      if (response.succeeded) {
        return Right(response.message);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AgentEntity>> getAgentProfile() async {
    try {
      final response = await remoteDataSource.getAgentProfile();
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MaintenanceAssignedEntity>>> getAssignedMaintenance({int? decision}) async {
    try {
      final response = await remoteDataSource.getAssignedMaintenance(decision: decision);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> submitMaintenanceDecision(SubmitMaintenanceDecisionParams params) async {
    try {
      final request = MaintenanceDecisionRequestModel(
        decision: params.decision,
        postponedToDate: params.postponedToDate?.toIso8601String(),
        notes: params.notes,
      );
      final response = await remoteDataSource.submitMaintenanceDecision(params.maintenanceId, request);
      if (response.succeeded) {
        return Right(response.message);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty ? response.errors.join('\n') : response.message,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}

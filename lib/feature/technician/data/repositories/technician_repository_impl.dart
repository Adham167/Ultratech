import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ultra_tech/core/errors/failures.dart';
import 'package:ultra_tech/feature/Auth/data/models/response/user_profile_model.dart';
import 'package:ultra_tech/feature/technician/data/datasources/technician_remote_data_source.dart';
import 'package:ultra_tech/feature/technician/data/models/complete_order_request_model.dart';
import 'package:ultra_tech/feature/technician/data/models/invoice_model.dart';
import 'package:ultra_tech/feature/technician/data/models/order_model.dart';
import 'package:ultra_tech/feature/technician/data/models/product_model.dart';
import 'package:ultra_tech/feature/technician/data/models/earnings_model.dart';
import 'package:ultra_tech/feature/technician/domain/repositories/technician_repository.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  final TechnicianRemoteDataSource remoteDataSource;

  TechnicianRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OrderModel>>> getMyOrders({int? status}) async {
    try {
      final response = await remoteDataSource.getMyOrders(status: status);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : (response.message.isNotEmpty ? response.message : 'فشل في جلب الأوردرات'),
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
  Future<Either<Failure, String>> acceptOrder(int orderId) async {
    try {
      final response = await remoteDataSource.acceptOrder(orderId);
      if (response.succeeded) {
        return Right(
          response.data ?? (response.message.isNotEmpty ? response.message : 'تم قبول الأوردر بنجاح'),
        );
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : (response.message.isNotEmpty ? response.message : 'فشل في قبول الأوردر'),
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
  Future<Either<Failure, String>> startOrder(int orderId) async {
    try {
      final response = await remoteDataSource.startOrder(orderId);
      if (response.succeeded) {
        return Right(
          response.data ?? (response.message.isNotEmpty ? response.message : 'تم التأكيد وبدء العمل بنجاح'),
        );
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : (response.message.isNotEmpty ? response.message : 'فشل في بدء العمل'),
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
  Future<Either<Failure, String>> completeOrder(int orderId, CompleteOrderRequestModel request) async {
    try {
      final response = await remoteDataSource.completeOrder(orderId, request);
      if (response.succeeded) {
        return Right(
          response.data ?? (response.message.isNotEmpty ? response.message : 'تم إنهاء العمل وإصدار الفاتورة بنجاح'),
        );
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : (response.message.isNotEmpty ? response.message : 'فشل في إنهاء الأوردر'),
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
  Future<Either<Failure, List<ProductModel>>> getProducts({bool onlyInStock = true}) async {
    try {
      final response = await remoteDataSource.getProducts(onlyInStock: onlyInStock);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : (response.message.isNotEmpty ? response.message : 'فشل في جلب قائمة المنتجات'),
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
  Future<Either<Failure, List<InvoiceModel>>> getMyInvoices({int? status}) async {
    try {
      final response = await remoteDataSource.getMyInvoices(status: status);
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.errors.isNotEmpty
              ? response.errors.join('\n')
              : (response.message.isNotEmpty ? response.message : 'فشل في جلب قائمة الفواتير'),
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
  Future<Either<Failure, EarningsModel>> getMyEarnings() async {
    try {
      final response = await remoteDataSource.getMyEarnings();

      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ServerFailure(
            response.errors.isNotEmpty
                ? response.errors.join('\n')
                : (response.message.isNotEmpty
                    ? response.message
                    : 'فشل في جلب بيانات الأرباح'),
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvoiceModel>> getInvoiceById(int invoiceId) async {
    try {
      final response = await remoteDataSource.getInvoiceById(invoiceId);

      if (!response.succeeded || response.data == null) {
        return Left(
          ServerFailure(
            response.message.isNotEmpty
                ? response.message
                : 'فشل في جلب تفاصيل الفاتورة',
          ),
        );
      }

      return Right(response.data!);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'حدث خطأ أثناء جلب تفاصيل الفاتورة',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> getUserProfile() async {
    try {
      final response = await remoteDataSource.getUserProfile();
      if (response.succeeded && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ServerFailure(
            response.errors.isNotEmpty
                ? response.errors.join('\n')
                : (response.message.isNotEmpty
                    ? response.message
                    : 'فشل في جلب بيانات البروفايل'),
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}

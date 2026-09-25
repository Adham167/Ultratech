import 'package:fpdart/fpdart.dart';
import 'package:ultra_tech/core/errors/failures.dart';
import 'package:ultra_tech/feature/Auth/data/models/response/user_profile_model.dart';
import 'package:ultra_tech/feature/technician/data/models/complete_order_request_model.dart';
import 'package:ultra_tech/feature/technician/data/models/invoice_model.dart';
import 'package:ultra_tech/feature/technician/data/models/order_model.dart';
import 'package:ultra_tech/feature/technician/data/models/product_model.dart';
import 'package:ultra_tech/feature/technician/data/models/earnings_model.dart';

abstract class TechnicianRepository {
  Future<Either<Failure, List<OrderModel>>> getMyOrders({int? status});
  Future<Either<Failure, String>> acceptOrder(int orderId);
  Future<Either<Failure, String>> startOrder(int orderId);
  Future<Either<Failure, String>> completeOrder(int orderId, CompleteOrderRequestModel request);
  Future<Either<Failure, List<ProductModel>>> getProducts({bool onlyInStock = true});
  Future<Either<Failure, List<InvoiceModel>>> getMyInvoices({int? status});
  Future<Either<Failure, EarningsModel>> getMyEarnings();
  Future<Either<Failure, InvoiceModel>> getInvoiceById(int invoiceId);
  Future<Either<Failure, UserProfileModel>> getUserProfile();
}

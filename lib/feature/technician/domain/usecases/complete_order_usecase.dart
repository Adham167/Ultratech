import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/complete_order_request_model.dart';
import '../repositories/technician_repository.dart';

class CompleteOrderUseCase {
  final TechnicianRepository repository;

  CompleteOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(int orderId, CompleteOrderRequestModel request) {
    return repository.completeOrder(orderId, request);
  }
}

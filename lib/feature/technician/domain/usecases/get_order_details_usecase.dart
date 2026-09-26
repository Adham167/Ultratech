import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/order_model.dart';
import '../repositories/technician_repository.dart';

class GetOrderDetailsUseCase {
  final TechnicianRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<Either<Failure, OrderModel>> call(int orderId) {
    return repository.getOrderDetails(orderId);
  }
}
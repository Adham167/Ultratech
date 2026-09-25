import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/order_model.dart';
import '../repositories/technician_repository.dart';

class GetMyOrdersUseCase {
  final TechnicianRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderModel>>> call({int? status}) {
    return repository.getMyOrders(status: status);
  }
}

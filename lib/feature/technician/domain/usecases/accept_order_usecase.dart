import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/technician_repository.dart';

class AcceptOrderUseCase {
  final TechnicianRepository repository;

  AcceptOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(int orderId) {
    return repository.acceptOrder(orderId);
  }
}

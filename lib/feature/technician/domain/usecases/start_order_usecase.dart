import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/technician_repository.dart';

class StartOrderUseCase {
  final TechnicianRepository repository;

  StartOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(int orderId) {
    return repository.startOrder(orderId);
  }
}

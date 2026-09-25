import 'package:fpdart/fpdart.dart';
import 'package:ultra_tech/core/errors/failures.dart';
import 'package:ultra_tech/feature/technician/data/models/earnings_model.dart';
import 'package:ultra_tech/feature/technician/domain/repositories/technician_repository.dart';

class GetMyEarningsUseCase {
  final TechnicianRepository repository;

  GetMyEarningsUseCase(this.repository);

  Future<Either<Failure, EarningsModel>> call() {
    return repository.getMyEarnings();
  }
}
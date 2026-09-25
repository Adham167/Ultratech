import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/maintenance_assigned_entity.dart';
import '../repositories/sales_repository.dart';

class GetAssignedMaintenanceUseCase {
  final SalesRepository repository;

  GetAssignedMaintenanceUseCase(this.repository);

  Future<Either<Failure, List<MaintenanceAssignedEntity>>> call({int? decision}) async {
    return await repository.getAssignedMaintenance(decision: decision);
  }
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/sales_repository.dart';
import 'submit_maintenance_decision_params.dart';

class SubmitMaintenanceDecisionUseCase {
  final SalesRepository repository;

  SubmitMaintenanceDecisionUseCase(this.repository);

  Future<Either<Failure, String>> call(SubmitMaintenanceDecisionParams params) async {
    return await repository.submitMaintenanceDecision(params);
  }
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/agent_entity.dart';
import '../repositories/sales_repository.dart';

class GetAgentProfileUseCase {
  final SalesRepository repository;

  GetAgentProfileUseCase(this.repository);

  Future<Either<Failure, AgentEntity>> call() async {
    return await repository.getAgentProfile();
  }
}

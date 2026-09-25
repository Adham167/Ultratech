import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/area_entity.dart';
import '../repositories/sales_repository.dart';

class GetAreasUseCase {
  final SalesRepository repository;

  GetAreasUseCase(this.repository);

  Future<Either<Failure, List<AreaEntity>>> call() async {
    return await repository.getAreas();
  }
}

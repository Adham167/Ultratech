import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/customer_check_result_entity.dart';
import '../repositories/sales_repository.dart';

class CheckPhoneUseCase {
  final SalesRepository repository;

  CheckPhoneUseCase(this.repository);

  Future<Either<Failure, CustomerCheckResultEntity>> call(String phoneNumber) async {
    return await repository.checkPhone(phoneNumber);
  }
}

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/register_customer_params.dart';
import '../repositories/sales_repository.dart';

class RegisterCustomerUseCase {
  final SalesRepository repository;

  RegisterCustomerUseCase(this.repository);

  Future<Either<Failure, String>> call(RegisterCustomerParams params) async {
    return await repository.registerCustomer(params);
  }
}

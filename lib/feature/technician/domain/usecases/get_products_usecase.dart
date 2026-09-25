import 'package:fpdart/fpdart.dart';
import 'package:ultra_tech/core/errors/failures.dart';
import 'package:ultra_tech/feature/technician/data/models/product_model.dart';
import 'package:ultra_tech/feature/technician/domain/repositories/technician_repository.dart';

class GetProductsUseCase {
  final TechnicianRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call({bool onlyInStock = true}) {
    return repository.getProducts(onlyInStock: onlyInStock);
  }
}
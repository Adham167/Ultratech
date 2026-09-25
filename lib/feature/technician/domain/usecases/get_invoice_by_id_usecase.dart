import '../../data/models/invoice_model.dart';
import '../repositories/technician_repository.dart';
import '../../../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class GetInvoiceByIdUseCase {
  final TechnicianRepository repository;

  GetInvoiceByIdUseCase(this.repository);

  Future<Either<Failure, InvoiceModel>> call(
      int invoiceId,
      ) {
    return repository.getInvoiceById(invoiceId);
  }
}
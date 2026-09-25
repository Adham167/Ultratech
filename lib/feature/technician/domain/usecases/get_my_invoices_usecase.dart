import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/invoice_model.dart';
import '../repositories/technician_repository.dart';

class GetMyInvoicesUseCase {
  final TechnicianRepository repository;

  GetMyInvoicesUseCase(this.repository);

  Future<Either<Failure, List<InvoiceModel>>> call({int? status}) async {
    return await repository.getMyInvoices(status: status);
  }
}

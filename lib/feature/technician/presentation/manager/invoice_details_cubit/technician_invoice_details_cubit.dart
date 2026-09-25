import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/invoice_model.dart';
import '../../../domain/usecases/get_invoice_by_id_usecase.dart';


part 'technician_invoice_details_state.dart';

class TechnicianInvoiceDetailsCubit
    extends Cubit<TechnicianInvoiceDetailsState> {
  final GetInvoiceByIdUseCase getInvoiceByIdUseCase;

  TechnicianInvoiceDetailsCubit(
      this.getInvoiceByIdUseCase,
      ) : super(
    const TechnicianInvoiceDetailsInitial(),
  );

  Future<void> getInvoiceDetails(int invoiceId) async {
    emit(
      const TechnicianInvoiceDetailsLoading(),
    );

    final result = await getInvoiceByIdUseCase(
      invoiceId,
    );

    result.fold(
          (failure) {
        emit(
          TechnicianInvoiceDetailsError(
            failure.errMessage,
          ),
        );
      },
          (invoice) {
        emit(
          TechnicianInvoiceDetailsLoaded(
            invoice,
          ),
        );
      },
    );
  }
}
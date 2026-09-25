part of 'technician_invoice_details_cubit.dart';

abstract class TechnicianInvoiceDetailsState {
  const TechnicianInvoiceDetailsState();
}

class TechnicianInvoiceDetailsInitial
    extends TechnicianInvoiceDetailsState {
  const TechnicianInvoiceDetailsInitial();
}

class TechnicianInvoiceDetailsLoading
    extends TechnicianInvoiceDetailsState {
  const TechnicianInvoiceDetailsLoading();
}

class TechnicianInvoiceDetailsLoaded
    extends TechnicianInvoiceDetailsState {
  final InvoiceModel invoice;

  const TechnicianInvoiceDetailsLoaded(
      this.invoice,
      );
}

class TechnicianInvoiceDetailsError
    extends TechnicianInvoiceDetailsState {
  final String message;

  const TechnicianInvoiceDetailsError(
      this.message,
      );
}
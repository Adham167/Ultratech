import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/complete_order_request_model.dart';
import '../../../data/models/invoice_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';
import '../../../domain/usecases/accept_order_usecase.dart';
import '../../../domain/usecases/complete_order_usecase.dart';
import '../../../domain/usecases/get_my_invoices_usecase.dart';
import '../../../domain/usecases/get_my_orders_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/start_order_usecase.dart';
import 'technician_orders_state.dart';

class TechnicianOrdersCubit extends Cubit<TechnicianOrdersState> {
  final GetMyOrdersUseCase getMyOrdersUseCase;
  final AcceptOrderUseCase acceptOrderUseCase;
  final StartOrderUseCase startOrderUseCase;
  final CompleteOrderUseCase completeOrderUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetMyInvoicesUseCase getMyInvoicesUseCase;

  int? currentStatusFilter;
  List<OrderModel> cachedOrders = [];
  List<ProductModel> cachedProducts = [];
  List<InvoiceModel> cachedInvoices = [];

  TechnicianOrdersCubit({
    required this.getMyOrdersUseCase,
    required this.acceptOrderUseCase,
    required this.startOrderUseCase,
    required this.completeOrderUseCase,
    required this.getProductsUseCase,
    required this.getMyInvoicesUseCase,
  }) : super(TechnicianOrdersInitial());

  Future<void> getMyOrders({int? status, bool showLoading = true}) async {
    currentStatusFilter = status;
    if (showLoading) {
      emit(TechnicianOrdersLoading());
    }

    final result = await getMyOrdersUseCase(status: status);

    result.fold(
      (failure) => emit(TechnicianOrdersFailure(failure.errMessage)),
      (orders) {
        cachedOrders = orders;
        if (orders.isEmpty) {
          emit(TechnicianOrdersEmpty(currentStatusFilter: status));
        } else {
          emit(TechnicianOrdersSuccess(orders, currentStatusFilter: status));
        }
      },
    );
  }

  Future<void> acceptOrder(int orderId) async {
    emit(TechnicianActionLoading(orderId: orderId, actionType: 'accept'));

    final result = await acceptOrderUseCase(orderId);

    result.fold(
      (failure) => emit(TechnicianActionFailure(
        errMessage: failure.errMessage,
        actionType: 'accept',
      )),
      (message) {
        emit(TechnicianActionSuccess(
          message: message,
          actionType: 'accept',
          orderId: orderId,
        ));
        // Auto refresh list
        getMyOrders(status: currentStatusFilter, showLoading: false);
      },
    );
  }

  Future<void> startOrder(int orderId) async {
    emit(TechnicianActionLoading(orderId: orderId, actionType: 'start'));

    final result = await startOrderUseCase(orderId);

    result.fold(
      (failure) => emit(TechnicianActionFailure(
        errMessage: failure.errMessage,
        actionType: 'start',
      )),
      (message) {
        emit(TechnicianActionSuccess(
          message: message,
          actionType: 'start',
          orderId: orderId,
        ));
        // Auto refresh list
        getMyOrders(status: currentStatusFilter, showLoading: false);
      },
    );
  }

  Future<void> completeOrder(int orderId, CompleteOrderRequestModel request) async {
    emit(TechnicianActionLoading(orderId: orderId, actionType: 'complete'));

    final result = await completeOrderUseCase(orderId, request);

    result.fold(
      (failure) => emit(TechnicianActionFailure(
        errMessage: failure.errMessage,
        actionType: 'complete',
      )),
      (message) {
        emit(TechnicianActionSuccess(
          message: message,
          actionType: 'complete',
          orderId: orderId,
        ));
        // Auto refresh list
        getMyOrders(status: currentStatusFilter, showLoading: false);
      },
    );
  }

  Future<void> getProducts() async {
    emit(TechnicianProductsLoading());

    final result = await getProductsUseCase();

    result.fold(
      (failure) {
        emit(TechnicianProductsFailure(failure.errMessage));
      },
      (products) {
        cachedProducts = products;
        emit(TechnicianProductsSuccess(products));
      },
    );
  }

  Future<void> getMyInvoices({int? status, bool showLoading = true}) async {
    if (showLoading) {
      emit(TechnicianInvoicesLoading());
    }

    final result = await getMyInvoicesUseCase(status: status);

    result.fold(
      (failure) => emit(TechnicianInvoicesFailure(failure.errMessage)),
      (invoices) {
        cachedInvoices = invoices;
        emit(TechnicianInvoicesSuccess(invoices, currentStatusFilter: status));
      },
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/complete_order_request_model.dart';
import '../../../data/models/invoice_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';
import '../../../domain/usecases/accept_order_usecase.dart';
import '../../../domain/usecases/complete_order_usecase.dart';
import '../../../domain/usecases/get_my_invoices_usecase.dart';
import '../../../domain/usecases/get_my_orders_usecase.dart';
import '../../../domain/usecases/get_order_details_usecase.dart';
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
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  int? currentStatusFilter;

  List<OrderModel> cachedOrders = [];
  List<ProductModel> cachedProducts = [];
  List<InvoiceModel> cachedInvoices = [];

  TechnicianOrdersCubit({
    required this.getMyOrdersUseCase,
    required this.getOrderDetailsUseCase,
    required this.acceptOrderUseCase,
    required this.startOrderUseCase,
    required this.completeOrderUseCase,
    required this.getProductsUseCase,
    required this.getMyInvoicesUseCase,
  }) : super(TechnicianOrdersInitial());


  Future<OrderModel?> getOrderDetails(int orderId) async {
    debugPrint(
      'DEBUG: getOrderDetails called for orderId=$orderId',
    );

    try {
      final result = await getOrderDetailsUseCase(orderId);

      return result.fold(
            (failure) {
          debugPrint(
            'ERROR getOrderDetails: ${failure.errMessage}',
          );

          return null;
        },
            (order) {
          debugPrint(
            'DEBUG getOrderDetails SUCCESS: '
                'orderId=${order.id}, '
                'items=${order.items.length}, '
                'invoiceId=${order.invoiceId}',
          );

          return order;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR getOrderDetails: $e');
      debugPrintStack(stackTrace: stackTrace);

      return null;
    }
  }

  Future<void> getMyOrders({int? status, bool showLoading = true}) async {
    currentStatusFilter = status;

    if (showLoading) {
      emit(TechnicianOrdersLoading());
    }

    try {
      final result = await getMyOrdersUseCase(status: status);

      result.fold(
        (failure) {
          emit(TechnicianOrdersFailure(failure.errMessage));
        },
        (orders) {
          cachedOrders = List<OrderModel>.from(orders);

          if (orders.isEmpty) {
            emit(TechnicianOrdersEmpty(currentStatusFilter: status));
          } else {
            emit(TechnicianOrdersSuccess(orders, currentStatusFilter: status));
          }
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR getMyOrders: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(const TechnicianOrdersFailure('حدث خطأ أثناء جلب الأوردرات'));
    }
  }

  Future<void> acceptOrder(int orderId) async {
    debugPrint('DEBUG: acceptOrder called for orderId: $orderId');

    emit(TechnicianActionLoading(orderId: orderId, actionType: 'accept'));

    try {
      final result = await acceptOrderUseCase(orderId);

      await result.fold(
        (failure) async {
          emit(
            TechnicianActionFailure(
              errMessage: failure.errMessage,
              actionType: 'accept',
            ),
          );
        },
        (message) async {
          await getMyOrders(status: currentStatusFilter, showLoading: false);

          emit(
            TechnicianActionSuccess(
              message: message,
              actionType: 'accept',
              orderId: orderId,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR acceptOrder: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        const TechnicianActionFailure(
          errMessage: 'حدث خطأ أثناء قبول الأوردر',
          actionType: 'accept',
        ),
      );
    }
  }

  Future<void> startOrder(int orderId) async {
    debugPrint('DEBUG: startOrder called for orderId: $orderId');

    emit(TechnicianActionLoading(orderId: orderId, actionType: 'start'));

    try {
      final result = await startOrderUseCase(orderId);

      await result.fold(
        (failure) async {
          emit(
            TechnicianActionFailure(
              errMessage: failure.errMessage,
              actionType: 'start',
            ),
          );
        },
        (message) async {
          await getMyOrders(status: currentStatusFilter, showLoading: false);

          emit(
            TechnicianActionSuccess(
              message: message,
              actionType: 'start',
              orderId: orderId,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR startOrder: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        const TechnicianActionFailure(
          errMessage: 'حدث خطأ أثناء بدء العمل على الأوردر',
          actionType: 'start',
        ),
      );
    }
  }Future<void> completeOrder(
      int orderId,
      CompleteOrderRequestModel request,
      ) async {
    debugPrint(
      'DEBUG: completeOrder called for orderId=$orderId',
    );

    debugPrint(
      'DEBUG: Initial complete request=${request.toJson()}',
    );

    emit(
      TechnicianActionLoading(
        orderId: orderId,
        actionType: 'complete',
      ),
    );

    try {
      var finalRequest = request;

      /*
     * لو الشاشة لم ترسل items،
     * نجلب تفاصيل الأوردر من الـ backend أولاً.
     */
      if (request.items.isEmpty) {
        debugPrint(
          'DEBUG: completeOrder request has empty items. '
              'Fetching order details...',
        );

        final order = await getOrderDetailsUseCase(orderId);

        final detailedOrder = order.fold(
              (failure) {
            debugPrint(
              'ERROR fetching order details before complete: '
                  '${failure.errMessage}',
            );

            return null;
          },
              (order) {
            return order;
          },
        );

        if (detailedOrder == null) {
          emit(
            const TechnicianActionFailure(
              errMessage:
              'تعذر جلب تفاصيل الأوردر قبل إصدار الفاتورة',
              actionType: 'complete',
            ),
          );

          return;
        }

        debugPrint(
          'DEBUG: Detailed order loaded. '
              'items=${detailedOrder.items.length}',
        );

        final items = detailedOrder.items
            .map(
              (item) => CompleteOrderItemModel(
            productId: item.productId,
            quantity: item.quantity,
          ),
        )
            .toList();

        finalRequest = CompleteOrderRequestModel(
          laborCost: request.laborCost,
          paymentMethod: request.paymentMethod,
          items: items,
          notes: request.notes,
        );
      }

      debugPrint(
        'DEBUG: FINAL complete request=${finalRequest.toJson()}',
      );

      final result = await completeOrderUseCase(
        orderId,
        finalRequest,
      );

      await result.fold(
            (failure) async {
          debugPrint(
            'ERROR completeOrder API: ${failure.errMessage}',
          );

          emit(
            TechnicianActionFailure(
              errMessage: failure.errMessage,
              actionType: 'complete',
            ),
          );
        },
            (message) async {
          debugPrint(
            'DEBUG: completeOrder SUCCESS: $message',
          );

          await getMyOrders(
            status: currentStatusFilter,
            showLoading: false,
          );

          emit(
            TechnicianActionSuccess(
              message: message,
              actionType: 'complete',
              orderId: orderId,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR completeOrder: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        const TechnicianActionFailure(
          errMessage: 'حدث خطأ أثناء إنهاء الأوردر',
          actionType: 'complete',
        ),
      );
    }
  }

  Future<void> getProducts({bool onlyInStock = true}) async {
    emit(TechnicianProductsLoading());

    try {
      final result = await getProductsUseCase(onlyInStock: onlyInStock);

      result.fold(
        (failure) {
          emit(TechnicianProductsFailure(failure.errMessage));
        },
        (products) {
          cachedProducts = List<ProductModel>.from(products);

          emit(TechnicianProductsSuccess(products));
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR getProducts: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(const TechnicianProductsFailure('حدث خطأ أثناء جلب المنتجات'));
    }
  }

  Future<void> getMyInvoices({int? status, bool showLoading = true}) async {
    if (showLoading) {
      emit(TechnicianInvoicesLoading());
    }

    try {
      final result = await getMyInvoicesUseCase(status: status);

      result.fold(
        (failure) {
          emit(TechnicianInvoicesFailure(failure.errMessage));
        },
        (invoices) {
          cachedInvoices = List<InvoiceModel>.from(invoices);

          emit(
            TechnicianInvoicesSuccess(invoices, currentStatusFilter: status),
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR getMyInvoices: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(const TechnicianInvoicesFailure('حدث خطأ أثناء جلب الفواتير'));
    }
  }
}

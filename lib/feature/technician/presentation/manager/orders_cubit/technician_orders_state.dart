import 'package:equatable/equatable.dart';

import '../../../data/models/invoice_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';

abstract class TechnicianOrdersState extends Equatable {
  const TechnicianOrdersState();

  @override
  List<Object?> get props => [];
}

class TechnicianOrdersInitial extends TechnicianOrdersState {}

class TechnicianOrdersLoading extends TechnicianOrdersState {}

class TechnicianOrdersSuccess extends TechnicianOrdersState {
  final List<OrderModel> orders;
  final int? currentStatusFilter;

  const TechnicianOrdersSuccess(this.orders, {this.currentStatusFilter});

  @override
  List<Object?> get props => [orders, currentStatusFilter];
}

class TechnicianOrdersEmpty extends TechnicianOrdersState {
  final int? currentStatusFilter;

  const TechnicianOrdersEmpty({this.currentStatusFilter});

  @override
  List<Object?> get props => [currentStatusFilter];
}

class TechnicianOrdersFailure extends TechnicianOrdersState {
  final String errMessage;

  const TechnicianOrdersFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class TechnicianActionLoading extends TechnicianOrdersState {
  final int orderId;
  final String actionType;

  const TechnicianActionLoading({
    required this.orderId,
    required this.actionType,
  });

  @override
  List<Object?> get props => [orderId, actionType];
}

class TechnicianActionSuccess extends TechnicianOrdersState {
  final String message;
  final String actionType;
  final int orderId;

  const TechnicianActionSuccess({
    required this.message,
    required this.actionType,
    required this.orderId,
  });

  @override
  List<Object?> get props => [message, actionType, orderId];
}

class TechnicianActionFailure extends TechnicianOrdersState {
  final String errMessage;
  final String actionType;

  const TechnicianActionFailure({
    required this.errMessage,
    required this.actionType,
  });

  @override
  List<Object?> get props => [errMessage, actionType];
}

class TechnicianProductsLoading extends TechnicianOrdersState {}

class TechnicianProductsSuccess extends TechnicianOrdersState {
  final List<ProductModel> products;

  const TechnicianProductsSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class TechnicianProductsFailure extends TechnicianOrdersState {
  final String errMessage;

  const TechnicianProductsFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

class TechnicianInvoicesLoading extends TechnicianOrdersState {}

class TechnicianInvoicesSuccess extends TechnicianOrdersState {
  final List<InvoiceModel> invoices;
  final int? currentStatusFilter;

  const TechnicianInvoicesSuccess(this.invoices, {this.currentStatusFilter});

  @override
  List<Object?> get props => [invoices, currentStatusFilter];
}

class TechnicianInvoicesFailure extends TechnicianOrdersState {
  final String errMessage;

  const TechnicianInvoicesFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

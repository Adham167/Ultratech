import 'package:equatable/equatable.dart';
import '../../../technician/data/models/order_model.dart';

abstract class SalesOrderDetailsState extends Equatable {
  const SalesOrderDetailsState();

  @override
  List<Object?> get props => [];
}

class SalesOrderDetailsInitial extends SalesOrderDetailsState {}

class SalesOrderDetailsLoading extends SalesOrderDetailsState {}

class SalesOrderDetailsSuccess extends SalesOrderDetailsState {
  final OrderModel order;

  const SalesOrderDetailsSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class SalesOrderDetailsFailure extends SalesOrderDetailsState {
  final String errMessage;

  const SalesOrderDetailsFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

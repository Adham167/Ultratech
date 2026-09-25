import 'package:equatable/equatable.dart';
import '../../../technician/data/models/product_model.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderProductsLoaded extends CreateOrderState {
  final List<ProductModel> products;

  const CreateOrderProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class CreateOrderSuccess extends CreateOrderState {
  final String message;

  const CreateOrderSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateOrderFailure extends CreateOrderState {
  final String errMessage;

  const CreateOrderFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

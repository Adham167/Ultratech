import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../technician/data/models/product_model.dart';
import '../../data/models/create_order_request_dto.dart';
import '../../domain/repositories/sales_repository.dart';
import 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final SalesRepository repository;
  List<ProductModel> cachedProducts = [];

  CreateOrderCubit(this.repository) : super(CreateOrderInitial());

  Future<void> fetchProducts() async {
    final result = await repository.getProducts();
    result.fold(
      (_) => null,
      (products) {
        cachedProducts = products;
        emit(CreateOrderProductsLoaded(products));
      },
    );
  }

  Future<void> createOrder(CreateOrderRequestDto request) async {
    emit(CreateOrderLoading());
    final result = await repository.createOrder(request);
    result.fold(
      (failure) => emit(CreateOrderFailure(failure.errMessage)),
      (message) => emit(CreateOrderSuccess(message)),
    );
  }
}

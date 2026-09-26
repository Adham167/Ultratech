import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/create_order_request_dto.dart';
import '../../domain/repositories/sales_repository.dart';
import 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final SalesRepository repository;

  CreateOrderCubit(this.repository) : super(CreateOrderInitial());

  Future<void> createOrder(CreateOrderRequestDto request) async {
    emit(CreateOrderLoading());
    final result = await repository.createOrder(request);
    result.fold(
      (failure) => emit(CreateOrderFailure(failure.errMessage)),
      (message) => emit(CreateOrderSuccess(message)),
    );
  }
}

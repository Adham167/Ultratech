import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/sales_repository.dart';
import 'sales_order_details_state.dart';

class SalesOrderDetailsCubit extends Cubit<SalesOrderDetailsState> {
  final SalesRepository repository;

  SalesOrderDetailsCubit(this.repository) : super(SalesOrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    emit(SalesOrderDetailsLoading());
    final result = await repository.getOrderDetails(orderId);
    result.fold(
      (failure) => emit(SalesOrderDetailsFailure(failure.errMessage)),
      (order) => emit(SalesOrderDetailsSuccess(order)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/sales_repository.dart';
import 'customer_profile_state.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  final SalesRepository repository;

  CustomerProfileCubit(this.repository) : super(CustomerProfileInitial());

  Future<void> getCustomerProfile(int customerId) async {
    emit(CustomerProfileLoading());
    final result = await repository.getCustomerProfile(customerId);
    result.fold(
      (failure) => emit(CustomerProfileFailure(failure.errMessage)),
      (profile) => emit(CustomerProfileSuccess(profile)),
    );
  }
}

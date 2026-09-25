import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/register_customer_params.dart';
import '../../domain/usecases/check_phone_usecase.dart';
import '../../domain/usecases/get_areas_usecase.dart';
import '../../domain/usecases/register_customer_usecase.dart';
import 'customer_registration_state.dart';

class CustomerRegistrationCubit extends Cubit<CustomerRegistrationState> {
  final CheckPhoneUseCase checkPhoneUseCase;
  final GetAreasUseCase getAreasUseCase;
  final RegisterCustomerUseCase registerCustomerUseCase;

  CustomerRegistrationCubit({
    required this.checkPhoneUseCase,
    required this.getAreasUseCase,
    required this.registerCustomerUseCase,
  }) : super(CustomerRegistrationInitial());

  Future<void> checkPhone(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    
    emit(PhoneSearchLoading());
    final result = await checkPhoneUseCase(phoneNumber);

    result.fold(
      (failure) => emit(PhoneSearchFailure(failure.errMessage)),
      (checkResult) => emit(PhoneSearchSuccess(checkResult, phoneNumber)),
    );
  }

  Future<void> fetchAreas() async {
    emit(AreasLoading());
    final result = await getAreasUseCase();

    result.fold(
      (failure) => emit(AreasFailure(failure.errMessage)),
      (areas) => emit(AreasSuccess(areas)),
    );
  }

  Future<void> registerCustomer(RegisterCustomerParams params) async {
    emit(RegisterCustomerLoading());
    final result = await registerCustomerUseCase(params);

    result.fold(
      (failure) => emit(RegisterCustomerFailure(failure.errMessage)),
      (message) {
        emit(RegisterCustomerSuccess(message));
      },
    );
  }

  void resetSearch() {
    emit(CustomerRegistrationInitial());
    fetchAreas(); // Ensure areas are fetched again
  }
}

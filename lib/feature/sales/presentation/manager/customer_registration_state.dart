import 'package:equatable/equatable.dart';
import '../../domain/entities/area_entity.dart';
import '../../domain/entities/customer_check_result_entity.dart';

abstract class CustomerRegistrationState extends Equatable {
  const CustomerRegistrationState();

  @override
  List<Object?> get props => [];
}

class CustomerRegistrationInitial extends CustomerRegistrationState {}

// Phone Search States
class PhoneSearchLoading extends CustomerRegistrationState {}

class PhoneSearchSuccess extends CustomerRegistrationState {
  final CustomerCheckResultEntity result;
  final String searchedPhone;
  const PhoneSearchSuccess(this.result, this.searchedPhone);

  @override
  List<Object?> get props => [result, searchedPhone];
}

class PhoneSearchFailure extends CustomerRegistrationState {
  final String errMessage;
  const PhoneSearchFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

// Areas States
class AreasLoading extends CustomerRegistrationState {}

class AreasSuccess extends CustomerRegistrationState {
  final List<AreaEntity> areas;
  const AreasSuccess(this.areas);

  @override
  List<Object?> get props => [areas];
}

class AreasFailure extends CustomerRegistrationState {
  final String errMessage;
  const AreasFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

// Registration States
class RegisterCustomerLoading extends CustomerRegistrationState {}

class RegisterCustomerSuccess extends CustomerRegistrationState {
  final String message;
  const RegisterCustomerSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterCustomerFailure extends CustomerRegistrationState {
  final String errMessage;
  const RegisterCustomerFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

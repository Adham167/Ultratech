import 'package:equatable/equatable.dart';
import '../../data/models/customer_profile_model.dart';

abstract class CustomerProfileState extends Equatable {
  const CustomerProfileState();

  @override
  List<Object?> get props => [];
}

class CustomerProfileInitial extends CustomerProfileState {}

class CustomerProfileLoading extends CustomerProfileState {}

class CustomerProfileSuccess extends CustomerProfileState {
  final CustomerProfileModel profile;

  const CustomerProfileSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class CustomerProfileFailure extends CustomerProfileState {
  final String errMessage;

  const CustomerProfileFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}

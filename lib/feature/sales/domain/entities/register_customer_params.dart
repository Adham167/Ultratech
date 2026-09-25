import 'package:equatable/equatable.dart';

class RegisterCustomerParams extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String address;
  final int areaId;

  const RegisterCustomerParams({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.areaId,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, address, areaId];
}

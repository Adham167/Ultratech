import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final int areaId;
  final String areaName;
  final int registeredBySalesId;
  final String registeredBySalesName;
  final DateTime createdAt;
  final int devicesCount;
  final int ordersCount;

  const CustomerEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.areaId,
    required this.areaName,
    required this.registeredBySalesId,
    required this.registeredBySalesName,
    required this.createdAt,
    required this.devicesCount,
    required this.ordersCount,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        address,
        areaId,
        areaName,
        registeredBySalesId,
        registeredBySalesName,
        createdAt,
        devicesCount,
        ordersCount,
      ];
}

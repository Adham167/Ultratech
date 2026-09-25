import '../../domain/entities/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    required super.address,
    required super.areaId,
    required super.areaName,
    required super.registeredBySalesId,
    required super.registeredBySalesName,
    required super.createdAt,
    required super.devicesCount,
    required super.ordersCount,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      areaId: json['areaId'] ?? 0,
      areaName: json['areaName'] ?? '',
      registeredBySalesId: json['registeredBySalesId'] ?? 0,
      registeredBySalesName: json['registeredBySalesName'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      devicesCount: json['devicesCount'] ?? 0,
      ordersCount: json['ordersCount'] ?? 0,
    );
  }
}

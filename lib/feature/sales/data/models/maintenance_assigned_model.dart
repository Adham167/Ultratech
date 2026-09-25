import '../../domain/entities/maintenance_assigned_entity.dart';

class MaintenanceAssignedModel extends MaintenanceAssignedEntity {
  const MaintenanceAssignedModel({
    required super.id,
    required super.customerId,
    required super.customerName,
    required super.customerPhone,
    required super.customerAddress,
    required super.areaName,
    required super.deviceName,
    required super.nextDueDate,
    required super.currentDecision,
  });

  factory MaintenanceAssignedModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceAssignedModel(
      id: json['id'] ?? 0,
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      areaName: json['areaName'] ?? '',
      deviceName: json['deviceName'] ?? '',
      nextDueDate: json['nextDueDate'] != null 
          ? DateTime.parse(json['nextDueDate']) 
          : DateTime.now(),
      currentDecision: json['currentDecision'] ?? 1,
    );
  }
}

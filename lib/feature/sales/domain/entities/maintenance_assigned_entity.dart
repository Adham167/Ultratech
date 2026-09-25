import 'package:equatable/equatable.dart';

class MaintenanceAssignedEntity extends Equatable {
  final int id;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String areaName;
  final String deviceName;
  final DateTime nextDueDate;
  final int currentDecision; // 1: Pending, 2: Approved, 3: Postponed, 4: Rejected

  const MaintenanceAssignedEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.areaName,
    required this.deviceName,
    required this.nextDueDate,
    required this.currentDecision,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        customerPhone,
        customerAddress,
        areaName,
        deviceName,
        nextDueDate,
        currentDecision,
      ];
}

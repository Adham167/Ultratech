import 'package:equatable/equatable.dart';

class AgentEntity extends Equatable {
  final int id;
  final String fullName;
  final String phoneNumber;
  final int areaId;
  final String areaName;
  final double baseSalary;
  final double commissionRate;

  const AgentEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.areaId,
    required this.areaName,
    required this.baseSalary,
    required this.commissionRate,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        areaId,
        areaName,
        baseSalary,
        commissionRate,
      ];
}

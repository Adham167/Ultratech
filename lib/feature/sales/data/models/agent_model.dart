import '../../domain/entities/agent_entity.dart';

class AgentModel extends AgentEntity {
  const AgentModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    required super.areaId,
    required super.areaName,
    required super.baseSalary,
    required super.commissionRate,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      areaId: json['areaId'] ?? 0,
      areaName: json['areaName'] ?? '',
      baseSalary: (json['baseSalary'] as num?)?.toDouble() ?? 0.0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

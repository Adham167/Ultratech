import '../../domain/entities/area_entity.dart';

class AreaModel extends AreaEntity {
  const AreaModel({
    required super.id,
    required super.name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

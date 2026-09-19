import '../../../domain/entities/user_entity.dart';
class UserDataModel extends UserEntity {
  const UserDataModel({
    required super.userId,
    required super.fullName,
    required super.phoneNumber,
    required super.email,
    required super.role,
    required super.roleName,
    required super.token,
    required super.refreshToken,
    required super.refreshTokenExpiration,
    required super.areaId,
    required super.isApproved,
    required super.isActive,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 0,
      roleName: json['roleName'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      refreshTokenExpiration: json['refreshTokenExpiration'] != null
          ? DateTime.parse(json['refreshTokenExpiration'])
          : DateTime(2099, 1, 1),
      areaId: json['areaId'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }
}

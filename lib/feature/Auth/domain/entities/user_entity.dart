import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final int role;
  final String roleName;
  final String token;
  final String refreshToken;
  final DateTime refreshTokenExpiration;
  final int areaId;
  final bool isApproved;
  final bool isActive;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.roleName,
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiration,
    required this.areaId,
    required this.isApproved,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        phoneNumber,
        email,
        role,
        roleName,
        token,
        refreshToken,
        refreshTokenExpiration,
        areaId,
        isApproved,
        isActive,
      ];
}

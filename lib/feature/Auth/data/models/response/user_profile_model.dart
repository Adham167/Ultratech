class UserProfileModel {
  final int userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final int role;
  final String roleName;
  final int areaId;
  final String areaName;
  final double baseSalary;
  final double commissionRate;
  final bool isApproved;
  final bool isActive;
  final String createdAt;

  const UserProfileModel({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.roleName,
    required this.areaId,
    required this.areaName,
    required this.baseSalary,
    required this.commissionRate,
    required this.isApproved,
    required this.isActive,
    required this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role'] is int
          ? json['role']
          : int.tryParse(json['role']?.toString() ?? '0') ?? 0,
      roleName: json['roleName']?.toString() ?? '',
      areaId: json['areaId'] is int
          ? json['areaId']
          : int.tryParse(json['areaId']?.toString() ?? '0') ?? 0,
      areaName: json['areaName']?.toString() ?? '',
      baseSalary: (json['baseSalary'] is num)
          ? (json['baseSalary'] as num).toDouble()
          : 0.0,
      commissionRate: (json['commissionRate'] is num)
          ? (json['commissionRate'] as num).toDouble()
          : 0.0,
      isApproved: json['isApproved'] == true,
      isActive: json['isActive'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role,
      'roleName': roleName,
      'areaId': areaId,
      'areaName': areaName,
      'baseSalary': baseSalary,
      'commissionRate': commissionRate,
      'isApproved': isApproved,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}

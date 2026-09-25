class RegisterCustomerRequestModel {
  final String fullName;
  final String phoneNumber;
  final String address;
  final int areaId;

  RegisterCustomerRequestModel({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.areaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'areaId': areaId,
    };
  }
}

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final int role;

  RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
    };
  }
}
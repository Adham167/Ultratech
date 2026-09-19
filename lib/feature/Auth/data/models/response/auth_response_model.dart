
class AuthResponseModel<T> {
  final bool succeeded;
  final String message;
  final T? data;
  final List<String> errors;

  AuthResponseModel({
    required this.succeeded,
    required this.message,
    this.data,
    required this.errors,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return AuthResponseModel(
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : [],
    );
  }
}

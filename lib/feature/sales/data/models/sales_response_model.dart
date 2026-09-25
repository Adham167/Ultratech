class SalesResponseModel<T> {
  final bool succeeded;
  final String message;
  final T? data;
  final List<String> errors;

  SalesResponseModel({
    required this.succeeded,
    required this.message,
    this.data,
    required this.errors,
  });

  factory SalesResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return SalesResponseModel(
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : [],
    );
  }
}

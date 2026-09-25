class TechnicianResponseModel<T> {
  final bool succeeded;
  final String message;
  final T? data;
  final List<String> errors;

  TechnicianResponseModel({
    required this.succeeded,
    required this.message,
    this.data,
    required this.errors,
  });

  factory TechnicianResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return TechnicianResponseModel(
      succeeded: json['succeeded'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] != null && json['errors'] is List
          ? List<String>.from(json['errors'])
          : [],
    );
  }
}

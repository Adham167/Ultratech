import '../../domain/entities/customer_check_result_entity.dart';
import 'customer_model.dart';

class CustomerCheckResultModel extends CustomerCheckResultEntity {
  const CustomerCheckResultModel({
    required super.isExisting,
    super.customer,
  });

  factory CustomerCheckResultModel.fromJson(Map<String, dynamic> json) {
    return CustomerCheckResultModel(
      isExisting: json['isExisting'] ?? false,
      customer: json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'customer_entity.dart';

class CustomerCheckResultEntity extends Equatable {
  final bool isExisting;
  final CustomerEntity? customer;

  const CustomerCheckResultEntity({
    required this.isExisting,
    this.customer,
  });

  @override
  List<Object?> get props => [isExisting, customer];
}

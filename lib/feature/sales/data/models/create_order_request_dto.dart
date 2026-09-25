class CreateOrderItemDto {
  final int productId;
  final int quantity;

  const CreateOrderItemDto({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class CreateOrderRequestDto {
  final int customerId;
  final int type;
  final int? technicianId;
  final String? notes;
  final List<CreateOrderItemDto> items;

  const CreateOrderRequestDto({
    required this.customerId,
    required this.type,
    this.technicianId,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'customerId': customerId,
      'type': type,
      'items': items.map((e) => e.toJson()).toList(),
    };
    if (technicianId != null) map['technicianId'] = technicianId;
    if (notes != null && notes!.isNotEmpty) map['notes'] = notes;
    return map;
  }
}

class CompleteOrderItemModel {
  final int productId;
  final int quantity;

  const CompleteOrderItemModel({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CompleteOrderItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompleteOrderItemModel(
      productId: _parseInt(json['productId']),
      quantity: _parseInt(json['quantity']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class CompleteOrderRequestModel {
  final num laborCost;
  final int paymentMethod;
  final List<CompleteOrderItemModel> items;
  final String? notes;

  const CompleteOrderRequestModel({
    required this.laborCost,
    required this.paymentMethod,
    required this.items,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'laborCost': laborCost,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes ?? '',
    };
  }
}
class CompleteOrderItemModel {
  final int productId;
  final int quantity;

  CompleteOrderItemModel({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CompleteOrderItemModel.fromJson(Map<String, dynamic> json) {
    return CompleteOrderItemModel(
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}

class CompleteOrderRequestModel {
  final num laborCost;
  final int paymentMethod;
  final List<CompleteOrderItemModel> items;
  final String? notes;

  CompleteOrderRequestModel({
    required this.laborCost,
    required this.paymentMethod,
    required this.items,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'laborCost': laborCost,
      'paymentMethod': paymentMethod,
      'items': items.map((i) => i.toJson()).toList(),
      'notes': notes ?? '',
    };
  }
}

class ProductModel {
  final int id;
  final String name;
  final num retailPrice;
  final int stockQuantity;
  final bool isLowStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.retailPrice,
    required this.stockQuantity,
    this.isLowStock = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stock = json['stockQuantity'] is int
        ? json['stockQuantity']
        : (json['availableCount'] is int
            ? json['availableCount']
            : int.tryParse(json['stockQuantity']?.toString() ?? json['availableCount']?.toString() ?? '0') ?? 0);
    
    return ProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['productName']?.toString() ?? '',
      retailPrice: json['retailPrice'] is num
          ? json['retailPrice']
          : (json['unitRetailPrice'] is num
              ? json['unitRetailPrice']
              : (json['price'] is num
                  ? json['price']
                  : num.tryParse(json['retailPrice']?.toString() ?? json['price']?.toString() ?? '0') ?? 0)),
      stockQuantity: stock,
      isLowStock: json['isLowStock'] == true || stock < 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'retailPrice': retailPrice,
      'stockQuantity': stockQuantity,
      'isLowStock': isLowStock,
    };
  }
}

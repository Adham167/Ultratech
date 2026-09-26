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
    final stockVal = json['currentStock'] ?? json['stockQuantity'] ?? json['availableCount'];
    final stock = stockVal is int
        ? stockVal
        : (stockVal is num
            ? stockVal.toInt()
            : int.tryParse(stockVal?.toString() ?? '0') ?? 0);

    final idVal = json['id'];
    final id = idVal is int
        ? idVal
        : (idVal is num
            ? idVal.toInt()
            : int.tryParse(idVal?.toString() ?? '0') ?? 0);

    final priceVal = json['retailPrice'] ?? json['unitRetailPrice'] ?? json['price'];
    final retailPrice = priceVal is num
        ? priceVal
        : num.tryParse(priceVal?.toString() ?? '0') ?? 0;

    final name = json['name']?.toString() ?? json['productName']?.toString() ?? '';

    return ProductModel(
      id: id,
      name: name,
      retailPrice: retailPrice,
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

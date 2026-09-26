import 'package:ultra_tech/feature/technician/data/models/invoice_model.dart';

class OrderItemModel {
  final int productId;
  final String? productName;
  final int quantity;
  final num unitRetailPrice;
  final num totalPrice;

  const OrderItemModel({
    required this.productId,
    this.productName,
    required this.quantity,
    required this.unitRetailPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productId = _parseInt(json['productId']);
    final productName = json['productName']?.toString();
    final quantity = _parseInt(json['quantity']);
    final unitRetailPrice = _parseNum(json['unitRetailPrice']);
    final totalPrice = json['totalPrice'] != null
        ? _parseNum(json['totalPrice'])
        : unitRetailPrice * quantity;

    return OrderItemModel(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitRetailPrice: unitRetailPrice,
      totalPrice: totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitRetailPrice': unitRetailPrice,
      'totalPrice': totalPrice,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class OrderModel {
  final int id;
  final String orderNumber;
  final int type;
  final String typeText;
  final int status;
  final String statusText;

  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  final int areaId;
  final String areaName;

  final int technicianId;
  final String technicianName;

  final int? salesId;
  final String? salesName;

  final String? arrivedAt;
  final String? completedAt;
  final String? notes;
  final String createdAt;

  final int itemsCount;
  final num totalAmount;

  final int? invoiceId;
  final String? invoiceStatus;

  final double? customerLatitude;
  final double? customerLongitude;
  final String? customerGoogleMapsUrl;

  final List<OrderItemModel> items;
  final InvoiceModel? invoice;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.typeText,
    required this.status,
    required this.statusText,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.areaId,
    required this.areaName,
    required this.technicianId,
    required this.technicianName,
    this.salesId,
    this.salesName,
    this.arrivedAt,
    this.completedAt,
    this.notes,
    required this.createdAt,
    required this.itemsCount,
    required this.totalAmount,
    this.invoiceId,
    this.invoiceStatus,
    this.customerLatitude,
    this.customerLongitude,
    this.customerGoogleMapsUrl,
    required this.items,
    this.invoice,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    final List<OrderItemModel> parsedItems = (rawItems is List && rawItems.isNotEmpty)
        ? rawItems
            .whereType<Map>()
            .map(
              (item) => OrderItemModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList()
        : <OrderItemModel>[];

    InvoiceModel? parsedInvoice;
    final rawInvoice = json['invoice'];
    if (rawInvoice is Map && rawInvoice.isNotEmpty) {
      parsedInvoice = InvoiceModel.fromJson(
        Map<String, dynamic>.from(rawInvoice),
      );
    }

    return OrderModel(
      id: _parseInt(json['id']),
      orderNumber: json['orderNumber']?.toString() ?? '',
      type: _parseInt(json['type']),
      typeText: json['typeText']?.toString() ?? '',
      status: _parseInt(json['status']),
      statusText: json['statusText']?.toString() ?? '',
      customerId: _parseInt(json['customerId']),
      customerName: json['customerName']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? '',
      customerAddress: json['customerAddress']?.toString() ?? '',
      areaId: _parseInt(json['areaId']),
      areaName: json['areaName']?.toString() ?? '',
      technicianId: _parseInt(json['technicianId']),
      technicianName: json['technicianName']?.toString() ?? '',
      salesId: json['salesId'] != null ? _parseInt(json['salesId']) : null,
      salesName: json['salesName']?.toString(),
      arrivedAt: json['arrivedAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      itemsCount: json['itemsCount'] != null ? _parseInt(json['itemsCount']) : 0,
      totalAmount: json['totalAmount'] != null ? _parseNum(json['totalAmount']) : 0,
      invoiceId: json['invoiceId'] != null ? _parseInt(json['invoiceId']) : null,
      invoiceStatus: json['invoiceStatus']?.toString(),
      customerLatitude: json['customerLatitude'] != null ? _parseDouble(json['customerLatitude']) : null,
      customerLongitude: json['customerLongitude'] != null ? _parseDouble(json['customerLongitude']) : null,
      customerGoogleMapsUrl: json['customerGoogleMapsUrl']?.toString(),
      items: parsedItems,
      invoice: parsedInvoice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'type': type,
      'typeText': typeText,
      'status': status,
      'statusText': statusText,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'areaId': areaId,
      'areaName': areaName,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'salesId': salesId,
      'salesName': salesName,
      'arrivedAt': arrivedAt,
      'completedAt': completedAt,
      'notes': notes,
      'createdAt': createdAt,
      'itemsCount': itemsCount,
      'totalAmount': totalAmount,
      'invoiceId': invoiceId,
      'invoiceStatus': invoiceStatus,
      'customerLatitude': customerLatitude,
      'customerLongitude': customerLongitude,
      'customerGoogleMapsUrl': customerGoogleMapsUrl,
      'items': items.map((item) => item.toJson()).toList(),
      'invoice': invoice?.toJson(),
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}

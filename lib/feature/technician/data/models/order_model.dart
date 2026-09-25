import 'package:ultra_tech/feature/technician/data/models/invoice_model.dart';

class OrderItemModel {
  final int productId;
  final String? productName;
  final int quantity;
  final num unitRetailPrice;
  final num totalPrice;

  OrderItemModel({
    required this.productId,
    this.productName,
    required this.quantity,
    required this.unitRetailPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      productName: json['productName']?.toString(),
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      unitRetailPrice: json['unitRetailPrice'] is num
          ? json['unitRetailPrice']
          : num.tryParse(json['unitRetailPrice']?.toString() ?? '0') ?? 0,
      totalPrice: json['totalPrice'] is num
          ? json['totalPrice']
          : num.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0,
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
  final String? arrivedAt;
  final String? completedAt;
  final String? notes;
  final String createdAt;
  final int itemsCount;
  final num totalAmount;
  final int? invoiceId;
  final String? invoiceStatus;
  final List<OrderItemModel> items;
  final InvoiceModel? invoice;

  OrderModel({
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
    this.arrivedAt,
    this.completedAt,
    this.notes,
    required this.createdAt,
    required this.itemsCount,
    required this.totalAmount,
    this.invoiceId,
    this.invoiceStatus,
    required this.items,
    this.invoice,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderNumber: json['orderNumber']?.toString() ?? '',
      type: json['type'] is int ? json['type'] : int.tryParse(json['type']?.toString() ?? '0') ?? 0,
      typeText: json['typeText']?.toString() ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      statusText: json['statusText']?.toString() ?? '',
      customerId: json['customerId'] is int ? json['customerId'] : int.tryParse(json['customerId']?.toString() ?? '0') ?? 0,
      customerName: json['customerName']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? '',
      customerAddress: json['customerAddress']?.toString() ?? '',
      areaId: json['areaId'] is int ? json['areaId'] : int.tryParse(json['areaId']?.toString() ?? '0') ?? 0,
      areaName: json['areaName']?.toString() ?? '',
      technicianId: json['technicianId'] is int ? json['technicianId'] : int.tryParse(json['technicianId']?.toString() ?? '0') ?? 0,
      technicianName: json['technicianName']?.toString() ?? '',
      arrivedAt: json['arrivedAt']?.toString(),
      completedAt: json['completedAt']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      itemsCount: json['itemsCount'] is int ? json['itemsCount'] : int.tryParse(json['itemsCount']?.toString() ?? '0') ?? 0,
      totalAmount: json['totalAmount'] is num ? json['totalAmount'] : num.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,
      invoiceId: json['invoiceId'] != null ? (json['invoiceId'] is int ? json['invoiceId'] : int.tryParse(json['invoiceId'].toString())) : null,
      invoiceStatus: json['invoiceStatus']?.toString(),
      items: json['items'] != null && json['items'] is List
          ? (json['items'] as List).map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>)).toList()
          : [],
      invoice: json['invoice'] != null && json['invoice'] is Map<String, dynamic>
          ? InvoiceModel.fromJson(json['invoice'] as Map<String, dynamic>)
          : null,
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
      'arrivedAt': arrivedAt,
      'completedAt': completedAt,
      'notes': notes,
      'createdAt': createdAt,
      'itemsCount': itemsCount,
      'totalAmount': totalAmount,
      'invoiceId': invoiceId,
      'invoiceStatus': invoiceStatus,
      'items': items.map((e) => e.toJson()).toList(),
      'invoice': invoice?.toJson(),
    };
  }
}

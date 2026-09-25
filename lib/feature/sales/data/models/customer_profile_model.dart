class CustomerDeviceModel {
  final int productId;
  final String productName;
  final String? nextDueDate;
  final String? maintenanceStatus;

  const CustomerDeviceModel({
    required this.productId,
    required this.productName,
    this.nextDueDate,
    this.maintenanceStatus,
  });

  factory CustomerDeviceModel.fromJson(Map<String, dynamic> json) {
    return CustomerDeviceModel(
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId']?.toString() ?? '0') ?? 0,
      productName: json['productName']?.toString() ?? '',
      nextDueDate: json['nextDueDate']?.toString(),
      maintenanceStatus: json['maintenanceStatus']?.toString(),
    );
  }
}

class CustomerOrderModel {
  final int orderId;
  final String orderNumber;
  final String orderType;
  final String orderStatus;
  final String? technicianName;
  final String createdAt;
  final num totalAmount;

  const CustomerOrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.orderType,
    required this.orderStatus,
    this.technicianName,
    required this.createdAt,
    required this.totalAmount,
  });

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderModel(
      orderId: json['orderId'] is int
          ? json['orderId']
          : int.tryParse(json['orderId']?.toString() ?? json['id']?.toString() ?? '0') ?? 0,
      orderNumber: json['orderNumber']?.toString() ?? '',
      orderType: json['orderType']?.toString() ?? json['typeText']?.toString() ?? '',
      orderStatus: json['orderStatus']?.toString() ?? json['statusText']?.toString() ?? '',
      technicianName: json['technicianName']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      totalAmount: json['totalAmount'] is num
          ? json['totalAmount']
          : num.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,
    );
  }
}

class CustomerProfileModel {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final int areaId;
  final String areaName;
  final double? latitude;
  final double? longitude;
  final String? googleMapsUrl;
  final int devicesCount;
  final int ordersCount;
  final List<CustomerDeviceModel> devices;
  final List<CustomerOrderModel> orders;

  const CustomerProfileModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.areaId,
    required this.areaName,
    this.latitude,
    this.longitude,
    this.googleMapsUrl,
    required this.devicesCount,
    required this.ordersCount,
    required this.devices,
    required this.orders,
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      areaId: json['areaId'] is int
          ? json['areaId']
          : int.tryParse(json['areaId']?.toString() ?? '0') ?? 0,
      areaName: json['areaName']?.toString() ?? '',
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : double.tryParse(json['longitude']?.toString() ?? ''),
      googleMapsUrl: json['googleMapsUrl']?.toString(),
      devicesCount: json['devicesCount'] is int
          ? json['devicesCount']
          : int.tryParse(json['devicesCount']?.toString() ?? '0') ?? 0,
      ordersCount: json['ordersCount'] is int
          ? json['ordersCount']
          : int.tryParse(json['ordersCount']?.toString() ?? '0') ?? 0,
      devices: json['devices'] != null && json['devices'] is List
          ? (json['devices'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => CustomerDeviceModel.fromJson(e))
              .toList()
          : [],
      orders: json['orders'] != null && json['orders'] is List
          ? (json['orders'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => CustomerOrderModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

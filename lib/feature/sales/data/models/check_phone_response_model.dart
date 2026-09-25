class CustomerSummaryModel {
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

  const CustomerSummaryModel({
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
  });

  factory CustomerSummaryModel.fromJson(Map<String, dynamic> json) {
    return CustomerSummaryModel(
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
    );
  }
}

class CheckPhoneResponseModel {
  final bool isExisting;
  final CustomerSummaryModel? customer;

  const CheckPhoneResponseModel({
    required this.isExisting,
    this.customer,
  });

  factory CheckPhoneResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckPhoneResponseModel(
      isExisting: json['isExisting'] == true,
      customer: json['customer'] != null && json['customer'] is Map<String, dynamic>
          ? CustomerSummaryModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
    );
  }
}

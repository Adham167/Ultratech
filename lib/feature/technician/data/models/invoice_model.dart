class InvoiceItemModel {
  final int? productId;
  final String? productName;
  final num quantity;
  final num unitPrice;
  final num totalPrice;

  const InvoiceItemModel({
    this.productId,
    this.productName,
    this.quantity = 0,
    this.unitPrice = 0,
    this.totalPrice = 0,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId']?.toString() ?? ''),
      productName: json['productName']?.toString() ??
          json['ProductName']?.toString() ??
          json['name']?.toString() ??
          'قطعة غيار',
      quantity: _parseNum(json['quantity'] ?? json['Quantity'] ?? json['qty']),
      unitPrice: _parseNum(
        json['unitRetailPrice'] ??
            json['unitPrice'] ??
            json['UnitPrice'] ??
            json['price'],
      ),
      totalPrice: _parseNum(
        json['totalRetailPrice'] ??
            json['totalPrice'] ??
            json['TotalPrice'] ??
            json['total'],
      ),
    );
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class InvoiceModel {
  final int invoiceId;
  final String? invoiceNumber;

  final int? orderId;
  final String? orderNumber;

  final int? customerId;
  final String? customerName;
  final String? customerPhoneNumber;
  final String? areaName;

  final int? technicianId;
  final String? technicianName;

  final num laborCost;
  final num productsCost;
  final num totalAmount;

  final int paymentMethod;
  final String? paymentMethodName;

  final int? status;
  final String? statusText;

  final String? rejectionReason;

  final String? collectedByTechnicianAt;
  final String? confirmedByAccountantAt;
  final String? confirmedByAccountantName;
  final String? createdAt;

  final List<InvoiceItemModel> items;

  const InvoiceModel({
    required this.invoiceId,
    this.invoiceNumber,
    this.orderId,
    this.orderNumber,
    this.customerId,
    this.customerName,
    this.customerPhoneNumber,
    this.areaName,
    this.technicianId,
    this.technicianName,
    this.laborCost = 0,
    this.productsCost = 0,
    this.totalAmount = 0,
    this.paymentMethod = 1,
    this.paymentMethodName,
    this.status,
    this.statusText,
    this.rejectionReason,
    this.collectedByTechnicianAt,
    this.confirmedByAccountantAt,
    this.confirmedByAccountantName,
    this.createdAt,
    this.items = const [],
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapper structure from GET /api/Invoices/{id}
    final Map<String, dynamic> invoiceData =
        json.containsKey('invoice') && json['invoice'] is Map<String, dynamic>
            ? json['invoice'] as Map<String, dynamic>
            : json;

    final rawItems = json['items'] ?? json['Items'] ?? invoiceData['items'] ?? invoiceData['Items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(InvoiceItemModel.fromJson)
            .toList()
        : <InvoiceItemModel>[];

    final parsedStatus = _parseStatus(
      invoiceData['status'] ?? invoiceData['Status'],
      invoiceData['statusName'] ??
          invoiceData['statusText'] ??
          invoiceData['StatusName'],
    );

    final rawReason =
        (invoiceData['rejectionReason'] ?? invoiceData['RejectionReason'])
            ?.toString()
            .trim();
    final parsedReason = (rawReason != null &&
            rawReason.isNotEmpty &&
            rawReason != 'null' &&
            rawReason.toLowerCase() != 'string')
        ? rawReason
        : (parsedStatus == 4 || parsedStatus == 3 ? 'لا يوجد سبب محدد للرفض' : null);

    final rawOrderId = invoiceData['orderId'] ?? invoiceData['OrderId'];
    final rawOrderNumber = invoiceData['orderNumber']?.toString() ??
        invoiceData['OrderNumber']?.toString();

    final rawInvoiceId = invoiceData['id'] ??
        invoiceData['invoiceId'] ??
        invoiceData['InvoiceId'] ??
        invoiceData['Id'];

    return InvoiceModel(
      invoiceId: _parseInt(rawInvoiceId),
      invoiceNumber: invoiceData['invoiceNumber']?.toString() ??
          invoiceData['InvoiceNumber']?.toString() ??
          (rawInvoiceId != null ? 'INV-$rawInvoiceId' : 'غير متوفر'),

      orderId: _parseNullableInt(rawOrderId),
      orderNumber: (rawOrderNumber != null && rawOrderNumber.isNotEmpty)
          ? rawOrderNumber
          : rawOrderId?.toString(),

      customerId: _parseNullableInt(
        invoiceData['customerId'] ?? invoiceData['CustomerId'],
      ),
      customerName: invoiceData['customerName']?.toString() ??
          invoiceData['CustomerName']?.toString() ??
          'غير متوفر',
      customerPhoneNumber: invoiceData['customerPhoneNumber']?.toString() ??
          invoiceData['CustomerPhoneNumber']?.toString() ??
          invoiceData['customerPhone']?.toString() ??
          '',
      areaName: invoiceData['customerAreaName']?.toString() ??
          invoiceData['CustomerAreaName']?.toString() ??
          invoiceData['areaName']?.toString() ??
          invoiceData['area']?.toString() ??
          '',

      technicianId: _parseNullableInt(
        invoiceData['technicianId'] ?? invoiceData['TechnicianId'],
      ),
      technicianName: invoiceData['technicianName']?.toString() ??
          invoiceData['TechnicianName']?.toString(),

      laborCost: _parseNum(invoiceData['laborCost'] ?? invoiceData['LaborCost']),
      productsCost: _parseNum(
        invoiceData['productsCost'] ??
            invoiceData['ProductsCost'] ??
            invoiceData['itemsTotal'],
      ),
      totalAmount:
          _parseNum(invoiceData['totalAmount'] ?? invoiceData['TotalAmount']),

      paymentMethod: _parseInt(
        invoiceData['paymentMethod'] ?? invoiceData['PaymentMethod'],
        fallback: 1,
      ),
      paymentMethodName: invoiceData['paymentMethodName']?.toString() ??
          invoiceData['PaymentMethodName']?.toString(),

      status: parsedStatus,
      statusText: invoiceData['statusName']?.toString() ??
          invoiceData['StatusName']?.toString(),

      rejectionReason: parsedReason,

      collectedByTechnicianAt: invoiceData['collectedByTechnicianAt']?.toString(),
      confirmedByAccountantAt: invoiceData['confirmedByAccountantAt']?.toString(),
      confirmedByAccountantName:
          invoiceData['confirmedByAccountantName']?.toString(),

      createdAt: invoiceData['createdAt']?.toString() ??
          invoiceData['CreatedAt']?.toString(),

      items: items,
    );
  }

  static int _parseStatus(dynamic statusVal, dynamic statusTextVal) {
    if (statusVal != null) {
      if (statusVal is int) {
        if (statusVal == 1) return 1;
        if (statusVal == 2) return 2;
        if (statusVal == 3 || statusVal == 4) return 4;
      }
      final str = statusVal.toString().trim().toLowerCase();
      if (str == '1' || str == 'pending' || str == 'pendingconfirmation') return 1;
      if (str == '2' || str == 'confirmed') return 2;
      if (str == '3' || str == '4' || str == 'rejected') return 4;
    }

    if (statusTextVal != null) {
      final str = statusTextVal.toString().trim().toLowerCase();
      if (str.contains('pending')) return 1;
      if (str.contains('confirm')) return 2;
      if (str.contains('reject')) return 4;
    }

    return 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'invoiceNumber': invoiceNumber,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhoneNumber': customerPhoneNumber,
      'customerAreaName': areaName,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'laborCost': laborCost,
      'productsCost': productsCost,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentMethodName': paymentMethodName,
      'status': status,
      'statusName': statusText,
      'rejectionReason': rejectionReason,
      'collectedByTechnicianAt': collectedByTechnicianAt,
      'confirmedByAccountantAt': confirmedByAccountantAt,
      'confirmedByAccountantName': confirmedByAccountantName,
      'createdAt': createdAt,
      'items': items
          .map((item) => {
                'productId': item.productId,
                'productName': item.productName,
                'quantity': item.quantity,
                'unitPrice': item.unitPrice,
                'totalPrice': item.totalPrice,
              })
          .toList(),
    };
  }

  static int _parseInt(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) return value;

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    );
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;

    return num.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

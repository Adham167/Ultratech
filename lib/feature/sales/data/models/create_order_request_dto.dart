class CreateOrderRequestDto {
  final int customerId;
  final int type;
  final int? technicianId;
  final String? notes;

  const CreateOrderRequestDto({
    required this.customerId,
    required this.type,
    this.technicianId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'customerId': customerId,
      'type': type,
    };
    if (technicianId != null) map['technicianId'] = technicianId;
    if (notes != null && notes!.isNotEmpty) map['notes'] = notes;
    return map;
  }
}

typedef CreateOrderRequest = CreateOrderRequestDto;

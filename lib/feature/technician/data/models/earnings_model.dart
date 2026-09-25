class EarningsModel {
  final double baseSalary;
  final double commissionRate;
  final double pendingCommissionsAmount;
  final double confirmedUnpaidCommissionsAmount;
  final double paidCommissionsAmount;
  final int totalOrdersCompleted;

  const EarningsModel({
    required this.baseSalary,
    required this.commissionRate,
    required this.pendingCommissionsAmount,
    required this.confirmedUnpaidCommissionsAmount,
    required this.paidCommissionsAmount,
    required this.totalOrdersCompleted,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      baseSalary: _toDouble(json['baseSalary']),
      commissionRate: _toDouble(json['commissionRate']),
      pendingCommissionsAmount:
      _toDouble(json['pendingCommissionsAmount']),
      confirmedUnpaidCommissionsAmount:
      _toDouble(json['confirmedUnpaidCommissionsAmount']),
      paidCommissionsAmount:
      _toDouble(json['paidCommissionsAmount']),
      totalOrdersCompleted:
      _toInt(json['totalOrdersCompleted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseSalary': baseSalary,
      'commissionRate': commissionRate,
      'pendingCommissionsAmount': pendingCommissionsAmount,
      'confirmedUnpaidCommissionsAmount':
      confirmedUnpaidCommissionsAmount,
      'paidCommissionsAmount': paidCommissionsAmount,
      'totalOrdersCompleted': totalOrdersCompleted,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? 0;
  }
}
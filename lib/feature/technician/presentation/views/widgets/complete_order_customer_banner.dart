import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../data/models/order_model.dart';

class CompleteOrderCustomerBanner extends StatelessWidget {
  final OrderModel order;

  const CompleteOrderCustomerBanner({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderNumber = order.orderNumber.isNotEmpty
        ? order.orderNumber
        : order.id.toString();

    final orderType = order.typeText.isNotEmpty ? order.typeText : 'صيانة';

    final customerName = order.customerName.isNotEmpty
        ? order.customerName
        : 'عميل مسجل';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رقم الأوردر
          Text(
            'أوردر #$orderNumber',
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // نوع الأوردر
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                orderType,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // اسم العميل كاملًا
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  customerName,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

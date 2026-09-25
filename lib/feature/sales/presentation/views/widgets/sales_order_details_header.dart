import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../technician/data/models/order_model.dart';

class SalesOrderDetailsHeader extends StatelessWidget {
  final OrderModel order;

  const SalesOrderDetailsHeader({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'أوردر ${order.orderNumber.isNotEmpty ? order.orderNumber : "#${order.id}"}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingMedium.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.statusText.isNotEmpty ? order.statusText : 'نشط',
                  style: AppStyle.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.design_services_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text('نوع الخدمة: ${order.typeText}', style: AppStyle.hint),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text('تاريخ الإنشاء: ${order.createdAt.toReadableDateTime()}', style: AppStyle.hint),
            ],
          ),
        ],
      ),
    );
  }
}

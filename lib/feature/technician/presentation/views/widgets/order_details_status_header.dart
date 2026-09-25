import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/models/order_model.dart';

class OrderDetailsStatusHeader extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsStatusHeader({
    super.key,
    required this.order,
  });

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return AppColors.warning;
      case 2:
        return AppColors.sky;
      case 3:
        return AppColors.primary;
      case 4:
      case 5:
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }

  Color _getStatusBgColor(int status) {
    switch (status) {
      case 1:
        return AppColors.bgWarning;
      case 2:
        return AppColors.sky.withValues(alpha: 0.12);
      case 3:
        return AppColors.primaryLight.withValues(alpha: 0.25);
      case 4:
      case 5:
        return AppColors.bgSuccess;
      default:
        return AppColors.bgLight;
    }
  }

  String _getStatusLabel(int status, String statusText) {
    if (statusText.isNotEmpty) return statusText;

    switch (status) {
      case 1:
        return 'أوردر جديد';
      case 2:
        return 'تم القبول';
      case 3:
        return 'جاري العمل';
      case 4:
      case 5:
        return 'مكتمل';
      default:
        return 'غير محدد';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    final statusBgColor = _getStatusBgColor(order.status);
    final statusLabel = _getStatusLabel(order.status, order.statusText);

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
                  style: AppStyle.headingMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusLabel,
                  style: AppStyle.labelMedium.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'تاريخ الطلب: ${order.createdAt.toReadableDateTime()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.hint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

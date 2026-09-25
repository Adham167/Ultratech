import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';

class TechnicianOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const TechnicianOrderCard({
    super.key,
    required this.order,
    this.onTap,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header Row: Order ID & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      statusLabel,
                      style: AppStyle.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'أوردر ${order.orderNumber.isNotEmpty ? order.orderNumber : "#${order.id}"}',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingSmall.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Main Info: Customer Name & Short Area Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (order.areaName.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.areaName,
                        style: AppStyle.labelMedium.copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.customerName.isNotEmpty
                          ? order.customerName
                          : 'اسم العميل غير متوفر',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingSmall.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

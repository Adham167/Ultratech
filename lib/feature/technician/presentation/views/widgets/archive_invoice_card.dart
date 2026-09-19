import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class ArchiveInvoiceCard extends StatelessWidget {
  final String customerName;
  final String orderId;
  final String date;
  final String price;
  final String area;
  final bool isConfirmed;

  const ArchiveInvoiceCard({
    super.key,
    required this.customerName,
    required this.orderId,
    required this.date,
    required this.price,
    required this.area,
    required this.isConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppStyle.headingSmall.copyWith(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
              Text(
                customerName,
                style: AppStyle.headingSmall.copyWith(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$orderId • $date',
                style: AppStyle.hint.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isConfirmed ? AppColors.bgSuccess : AppColors.bgWarning,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isConfirmed ? AppColors.borderSuccess : AppColors.borderWarning,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isConfirmed ? Icons.check_circle_outline : Icons.access_time,
                      size: 12,
                      color: isConfirmed ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isConfirmed ? 'تم التأكيد' : 'في انتظار تأكيد المحاسب',
                      style: AppStyle.labelMedium.copyWith(
                        fontSize: 11,
                        color: isConfirmed ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  area,
                  style: AppStyle.labelMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.primary,
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

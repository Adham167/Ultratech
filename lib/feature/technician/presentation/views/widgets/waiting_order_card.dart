import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class WaitingOrderCard extends StatelessWidget {
  final String customerName;
  final String serviceType;
  final String time;
  final String area;

  const WaitingOrderCard({
    super.key,
    required this.customerName,
    required this.serviceType,
    required this.time,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.labelMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppStyle.headingSmall.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '$serviceType • $time',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

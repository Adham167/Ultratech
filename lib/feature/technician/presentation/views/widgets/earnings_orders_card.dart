import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class EarningsOrdersCard extends StatelessWidget {
  final int totalOrdersCompleted;

  const EarningsOrdersCard({
    super.key,
    required this.totalOrdersCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.task_alt,
              color: AppColors.primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'الأوردرات المكتملة',
                  style: AppStyle.bodySmall,
                ),
                const SizedBox(height: 3),
                Text(
                  '$totalOrdersCompleted أوردر',
                  style: AppStyle.headingMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

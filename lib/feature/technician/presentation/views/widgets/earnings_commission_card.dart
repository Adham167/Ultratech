import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class EarningsCommissionCard extends StatelessWidget {
  final double commissionRate;

  const EarningsCommissionCard({
    super.key,
    required this.commissionRate,
  });

  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2);
  }

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
              Icons.percent,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'نسبة العمولة',
                  style: AppStyle.bodySmall,
                ),
                const SizedBox(height: 3),
                Text(
                  '${_formatNumber(commissionRate)}%',
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

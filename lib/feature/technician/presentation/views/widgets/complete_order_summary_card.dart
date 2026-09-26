import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class CompleteOrderSummaryCard extends StatelessWidget {
  final num productsCost;
  final num laborCost;
  final num totalAmount;

  const CompleteOrderSummaryCard({
    super.key,
    required this.productsCost,
    required this.laborCost,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تكلفة المنتجات / قطع الغيار:', style: AppStyle.bodySmall),
              Text('$productsCost ج.م', style: AppStyle.labelMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المصنعية:', style: AppStyle.bodySmall),
              Text('$laborCost ج.م', style: AppStyle.labelMedium),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي النهائي:', style: AppStyle.headingSmall),
              Text(
                '$totalAmount ج.م',
                style: AppStyle.headingMedium.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

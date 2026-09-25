import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import 'order_details_section_card.dart';

class OrderDetailsBillingSummaryCard extends StatelessWidget {
  final num totalAmount;

  const OrderDetailsBillingSummaryCard({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'الملخص المالي',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '$totalAmount ج.م',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingMedium.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              const Text('إجمالي قيمة الأوردر', style: AppStyle.headingSmall),
            ],
          ),
        ],
      ),
    );
  }
}

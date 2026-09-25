import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../technician/data/models/order_model.dart';

class SalesOrderDetailsItemsCard extends StatelessWidget {
  final List<OrderItemModel> items;
  final num totalAmount;

  const SalesOrderDetailsItemsCard({
    super.key,
    required this.items,
    required this.totalAmount,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('قطع الغيار والمنتجات (${items.length})', style: AppStyle.headingSmall),
            ],
          ),
          const Divider(height: 20, color: AppColors.bgPage),
          if (items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('لا توجد منتجات مسجلة في هذا الأوردر', style: AppStyle.hint),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 12, color: AppColors.borderSubtle),
              itemBuilder: (context, index) {
                final item = items[index];
                return Row(
                  children: [
                    Text('${item.totalPrice} ج.م', style: AppStyle.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.productName ?? 'قطعة غيار', style: AppStyle.labelMedium),
                        Text('الكمية: ${item.quantity} | السعر: ${item.unitRetailPrice} ج.م', style: AppStyle.hint.copyWith(fontSize: 11)),
                      ],
                    ),
                  ],
                );
              },
            ),
          const Divider(height: 24, color: AppColors.bgPage),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$totalAmount ج.م', style: AppStyle.headingMedium.copyWith(color: AppColors.primary)),
              const Text('إجمالي قيمة الأوردر', style: AppStyle.headingSmall),
            ],
          ),
        ],
      ),
    );
  }
}

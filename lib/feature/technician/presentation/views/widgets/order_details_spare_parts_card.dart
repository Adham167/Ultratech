import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';
import 'order_details_section_card.dart';

class OrderDetailsSparePartsCard extends StatelessWidget {
  final List<OrderItemModel> items;

  const OrderDetailsSparePartsCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'قطع الغيار المطلوبة (${items.length})',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('القطعة', style: AppStyle.labelMedium),
              ),
              Expanded(
                child: Text('الكمية', textAlign: TextAlign.center, style: AppStyle.labelMedium),
              ),
              Expanded(
                flex: 2,
                child: Text('سعر القطعة', textAlign: TextAlign.left, style: AppStyle.labelMedium),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.borderSubtle),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.productName ?? 'قطعة غيار',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'x${item.quantity}',
                        textAlign: TextAlign.center,
                        style: AppStyle.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${item.unitRetailPrice} ج.م',
                        textAlign: TextAlign.left,
                        style: AppStyle.bodySmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

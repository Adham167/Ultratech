import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/product_model.dart';

class CompleteOrderProductItemRow extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const CompleteOrderProductItemRow({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: quantity > 0 ? AppColors.primary : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppStyle.labelMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${product.retailPrice} ج.م',
                      style: AppStyle.bodySmall.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'المتوفر: ${product.stockQuantity}',
                      style: AppStyle.labelSmall.copyWith(
                        fontSize: 10,
                        color: product.isLowStock ? AppColors.coral : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.coral, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: quantity > 0 ? () => onQuantityChanged(quantity - 1) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$quantity',
                  style: AppStyle.labelMedium.copyWith(
                    fontSize: 14,
                    color: quantity > 0 ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onQuantityChanged(quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

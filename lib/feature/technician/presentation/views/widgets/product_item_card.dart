import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class ProductItemCard extends StatelessWidget {
  final String name;
  final double price;
  final int availableCount;
  final bool isLowStock;
  final String? imageUrl;
  final int count;
  final ValueChanged<int>? onCountChanged;

  const ProductItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.availableCount,
    this.isLowStock = false,
    this.imageUrl,
    this.count = 0,
    this.onCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onCountChanged?.call(count + 1),
                icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  '$count',
                  style: AppStyle.labelMedium.copyWith(fontSize: 14),
                ),
              ),
              IconButton(
                onPressed: count > 0 ? () => onCountChanged?.call(count - 1) : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: count > 0 ? AppColors.textMuted : AppColors.borderDisabled,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.labelMedium.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isLowStock ? AppColors.bgError : AppColors.bgSuccess,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'المتوفر: $availableCount',
                        style: AppStyle.labelMedium.copyWith(
                          fontSize: 10,
                          color: isLowStock ? AppColors.coral : AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${price.toInt()} ج.م',
                      style: AppStyle.labelMedium.copyWith(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 50,
              height: 50,
              color: AppColors.bgLight,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.build_rounded,
                        color: AppColors.textHint,
                        size: 24,
                      ),
                    )
                  : const Icon(
                      Icons.build_rounded,
                      color: AppColors.textHint,
                      size: 24,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceSummaryCard extends StatelessWidget {
  final num productsCost;
  final num laborCost;
  final num totalAmount;
  final TextEditingController? laborCostController;
  final ValueChanged<String>? onLaborCostChanged;
  final bool isPaid;
  final ValueChanged<bool>? onPaidChanged;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const InvoiceSummaryCard({
    super.key,
    this.productsCost = 0,
    this.laborCost = 0,
    this.totalAmount = 0,
    this.laborCostController,
    this.onLaborCostChanged,
    this.isPaid = false,
    this.onPaidChanged,
    this.onSubmit,
    this.isLoading = false,
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
          const Text('تكلفة التركيب والمصنعية', style: AppStyle.labelSmall),
          const SizedBox(height: 6),
          TextField(
            controller: laborCostController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onChanged: onLaborCostChanged,
            decoration: InputDecoration(
              hintText: '250',
              suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('ج.م', style: AppStyle.labelSmall),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$productsCost ج.م', style: AppStyle.headingSmall),
              const Text('إجمالي المنتجات', style: AppStyle.labelSmall),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$laborCost ج.م', style: AppStyle.headingSmall),
              const Text('المصنعية', style: AppStyle.labelSmall),
            ],
          ),
          const Divider(height: 20, color: AppColors.bgPage),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalAmount ج.م',
                style: AppStyle.headingSmall.copyWith(color: AppColors.primary),
              ),
              const Text('الإجمالي النهائي', style: AppStyle.headingSmall),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPaid ? AppColors.bgSuccess : AppColors.bgPage,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPaid ? AppColors.borderSuccess : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isPaid,
                  activeThumbColor: AppColors.success,
                  onChanged: onPaidChanged,
                ),
                Text(
                  'تم استلام المبلغ نقداً',
                  style: AppStyle.labelMedium.copyWith(
                    color: isPaid ? AppColors.success : AppColors.textBody,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPaid ? AppColors.coral : AppColors.coral.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('إنهاء العمل والإغلاق', style: AppStyle.button),
            ),
          ),
        ],
      ),
    );
  }
}

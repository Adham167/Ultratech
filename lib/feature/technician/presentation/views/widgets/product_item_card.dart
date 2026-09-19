import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class ProductItemCard extends StatefulWidget {
  final String name;
  final double price;
  final int availableCount;
  final bool isLowStock;
  final String? imageUrl;

  const ProductItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.availableCount,
    this.isLowStock = false,
    this.imageUrl,
  });

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  int count = 0;

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
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => count++),
                icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 26),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$count',
                  style: AppStyle.labelMedium.copyWith(fontSize: 14),
                ),
              ),
              IconButton(
                onPressed: count > 0 ? () => setState(() => count--) : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: count > 0 ? AppColors.textMuted : AppColors.borderDisabled,
                  size: 26,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.name,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.labelMedium.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.price.toInt()} ج.م',
                  style: AppStyle.labelMedium.copyWith(
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.isLowStock ? AppColors.bgError : AppColors.bgSuccess,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'المتوفر: ${widget.availableCount}',
                    style: AppStyle.labelMedium.copyWith(
                      fontSize: 10,
                      color: widget.isLowStock ? AppColors.coral : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              color: AppColors.bgLight,
              child: widget.imageUrl != null
                  ? Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.build_rounded,
                        color: AppColors.textHint,
                        size: 28,
                      ),
                    )
                  : const Icon(
                      Icons.build_rounded,
                      color: AppColors.textHint,
                      size: 28,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceSummaryCard extends StatefulWidget {
  const InvoiceSummaryCard({super.key});

  @override
  State<InvoiceSummaryCard> createState() => _InvoiceSummaryCardState();
}

class _InvoiceSummaryCardState extends State<InvoiceSummaryCard> {
  bool isPaid = false;

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
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 ج.م', style: AppStyle.headingSmall),
              Text('إجمالي المنتجات', style: AppStyle.labelSmall),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('250 ج.م', style: AppStyle.headingSmall),
              Text('المصنعية', style: AppStyle.labelSmall),
            ],
          ),
          const Divider(height: 20, color: AppColors.bgPage),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '250 ج.م',
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
                  activeColor: AppColors.success,
                  onChanged: (val) => setState(() => isPaid = val),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isPaid ? AppColors.coral : AppColors.coral.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('إنهاء العمل والإغلاق', style: AppStyle.button),
            ),
          ),
        ],
      ),
    );
  }
}

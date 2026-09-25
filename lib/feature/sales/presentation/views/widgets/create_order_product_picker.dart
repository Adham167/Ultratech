import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../technician/data/models/product_model.dart';

class CreateOrderProductPicker extends StatefulWidget {
  final List<ProductModel> products;
  final Map<int, int> selectedItems; // productId -> quantity
  final ValueChanged<Map<int, int>> onChanged;

  const CreateOrderProductPicker({
    super.key,
    required this.products,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  State<CreateOrderProductPicker> createState() => _CreateOrderProductPickerState();
}

class _CreateOrderProductPickerState extends State<CreateOrderProductPicker> {
  String _searchQuery = '';

  void _updateQuantity(int productId, int delta) {
    final map = Map<int, int>.from(widget.selectedItems);
    final currentQty = map[productId] ?? 0;
    final newQty = currentQty + delta;

    if (newQty <= 0) {
      map.remove(productId);
    } else {
      map[productId] = newQty;
    }

    widget.onChanged(map);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.contains(_searchQuery) || p.id.toString().contains(_searchQuery);
    }).toList();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.selectedItems.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bgSuccess,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'تم تحديد ${widget.selectedItems.length} عنصر',
                    style: AppStyle.labelSmall.copyWith(color: AppColors.success),
                  ),
                ),
              const Text('اختر المنتجات وقطع الغيار', style: AppStyle.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'ابحث باسم المنتج أو الكود...',
              hintStyle: AppStyle.hint,
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: AppColors.bgPage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('لا توجد منتجات مطابقة للبحث', style: AppStyle.hint),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const Divider(height: 12, color: AppColors.borderSubtle),
              itemBuilder: (context, index) {
                final product = filtered[index];
                final qty = widget.selectedItems[product.id] ?? 0;
                final subtotal = product.retailPrice * qty;

                return Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _updateQuantity(product.id, -1),
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.coral, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$qty',
                            style: AppStyle.headingSmall.copyWith(
                              color: qty > 0 ? AppColors.primary : AppColors.textMuted,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _updateQuantity(product.id, 1),
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(product.name, style: AppStyle.labelMedium, textAlign: TextAlign.right),
                          const SizedBox(height: 2),
                          Text(
                            qty > 0
                                ? '${product.retailPrice} ج.م/قطعة | المجموع: $subtotal ج.م'
                                : '${product.retailPrice} ج.م',
                            style: AppStyle.hint.copyWith(
                              color: qty > 0 ? AppColors.primary : AppColors.textMuted,
                              fontWeight: qty > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

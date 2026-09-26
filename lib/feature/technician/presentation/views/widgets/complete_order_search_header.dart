import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class CompleteOrderSearchHeader extends StatelessWidget {
  final String searchTerm;
  final ValueChanged<String> onSearchChanged;
  final bool onlyInStock;
  final ValueChanged<bool> onInStockToggled;
  final bool showSelectedOnly;
  final ValueChanged<bool> onSelectedOnlyToggled;

  const CompleteOrderSearchHeader({
    super.key,
    required this.searchTerm,
    required this.onSearchChanged,
    required this.onlyInStock,
    required this.onInStockToggled,
    required this.showSelectedOnly,
    required this.onSelectedOnlyToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onSearchChanged,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'ابحث باسم المنتج أو قطعة الغيار...',
            hintStyle: AppStyle.hint,
            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: AppColors.bgPage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('متوفر بالمخزن فقط', style: AppStyle.labelSmall),
                selected: onlyInStock,
                selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                onSelected: onInStockToggled,
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('المحددة فقط', style: AppStyle.labelSmall),
                selected: showSelectedOnly,
                selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                onSelected: onSelectedOnlyToggled,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

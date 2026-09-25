import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class CreateOrderTypeSelector extends StatelessWidget {
  final int selectedType;
  final ValueChanged<int> onTypeChanged;

  const CreateOrderTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
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
          const Text('نوع الأوردر المطلوب', style: AppStyle.labelMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTypeTab(1, 'تركيب', Icons.build_circle_outlined),
              const SizedBox(width: 8),
              _buildTypeTab(2, 'صيانة دورية', Icons.settings_suggest_outlined),
              const SizedBox(width: 8),
              _buildTypeTab(3, 'طوارئ', Icons.warning_amber_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab(int type, String label, IconData icon) {
    final isSelected = selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => onTypeChanged(type),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.bgLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppStyle.labelSmall.copyWith(
                  color: isSelected ? Colors.white : AppColors.textHeading,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

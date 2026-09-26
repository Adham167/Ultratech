import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class OrderDetailsInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const OrderDetailsInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyle.hint,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
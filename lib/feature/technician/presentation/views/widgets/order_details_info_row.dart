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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(label, style: AppStyle.hint),
        ],
      ),
    );
  }
}

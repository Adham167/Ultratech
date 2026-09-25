import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class EarningsProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const EarningsProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text('$label: ', style: AppStyle.hint),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
        ),
      ],
    );
  }
}

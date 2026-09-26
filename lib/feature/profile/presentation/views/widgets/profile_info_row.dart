import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 8),

        // Label
        Text(
          '$label: ',
          style: AppStyle.hint,
        ),

        // Value
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            softWrap: true,
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
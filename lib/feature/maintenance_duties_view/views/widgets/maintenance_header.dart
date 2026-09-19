import 'package:flutter/material.dart';
import '../../../../core/utils/app_style.dart';

class MaintenanceHeader extends StatelessWidget {
  const MaintenanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'قائمة الصيانة الدورية',
          textAlign: TextAlign.right,
          style: AppStyle.headingLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'المهام الروتينية المسندة إليك اليوم وهذا الأسبوع.',
          textAlign: TextAlign.right,
          style: AppStyle.bodySmall,
        ),
      ],
    );
  }
}

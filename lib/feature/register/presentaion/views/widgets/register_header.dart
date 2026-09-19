import 'package:flutter/material.dart';

import '../../../../../core/utils/app_style.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'البحث وتسجيل العملاء',
          textAlign: TextAlign.right,
          style: AppStyle.headingLarge,
        ),
        SizedBox(height: 4),
        Text(
          'ابحث برقم الهاتف ثم أكمل البيانات.',
          textAlign: TextAlign.right,
          style: AppStyle.bodyMedium,
        ),
      ],
    );
  }
}

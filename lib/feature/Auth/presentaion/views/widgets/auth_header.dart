import 'package:flutter/material.dart';

import '../../../../../core/utils/app_style.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: AppStyle.headingLarge,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppStyle.bodyMedium,
        ),
      ],
    );
  }
}

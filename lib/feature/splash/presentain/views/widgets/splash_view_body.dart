import 'package:flutter/material.dart';

import '../../../../../core/utils/app_style.dart';


class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.build_circle_rounded,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Ultratech', style: AppStyle.splashTitle),
          const SizedBox(height: 8),
          const Text(
            'حلول الصيانة والمبيعات الميدانية',
            style: AppStyle.splashSubtitle,
          ),
        ],
      ),
    );
  }
}

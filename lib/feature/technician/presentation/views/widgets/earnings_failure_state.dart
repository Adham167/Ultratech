import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class EarningsFailureState extends StatelessWidget {
  final String errMessage;
  final VoidCallback onRetry;

  const EarningsFailureState({
    super.key,
    required this.errMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: AppColors.coral,
            ),
            const SizedBox(height: 12),
            Text(
              errMessage,
              textAlign: TextAlign.center,
              style: AppStyle.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'إعادة المحاولة',
                style: AppStyle.buttonSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

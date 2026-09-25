import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class CreateOrderBottomBar extends StatelessWidget {
  final num totalAmount;
  final bool isLoading;
  final VoidCallback onSubmit;

  const CreateOrderBottomBar({
    super.key,
    required this.totalAmount,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalAmount ج.م',
                  style: AppStyle.headingMedium.copyWith(color: AppColors.primary),
                ),
                const Text('إجمالي القيمة التقديرية:', style: AppStyle.labelMedium),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.rate_review_outlined, size: 20, color: Colors.white),
                label: Text(
                  isLoading ? 'جاري المعالجة...' : 'حفظ ومراجعة الأوردر',
                  style: AppStyle.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

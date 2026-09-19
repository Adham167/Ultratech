import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import 'custom_button.dart';

class PendingApprovalViewBody extends StatelessWidget {
  const PendingApprovalViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hourglass_empty_rounded,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 30),
            const Text(
              'حسابك قيد المراجعة',
              style: AppStyle.headingLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'شكراً لانضمامك إلينا. حسابك حالياً قيد المراجعة من قبل الإدارة، سنقوم بتفعيل حسابك في أقرب وقت ممكن.',
              style: AppStyle.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'التحقق من حالة الحساب (تسجيل دخول)',
              onPressed: () {
                context.go(AppRouter.kLoginView);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go(AppRouter.kLoginView);
              },
              child: Text(
                'العودة لتسجيل الدخول',
                style: AppStyle.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

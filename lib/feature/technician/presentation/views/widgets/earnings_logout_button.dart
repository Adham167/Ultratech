import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/service_locator.dart';

class EarningsLogoutButton extends StatelessWidget {
  const EarningsLogoutButton({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.bgCard,
            title: Row(
              children: [
                const Icon(Icons.logout_rounded, color: AppColors.coral, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'تسجيل الخروج',
                  style: AppStyle.headingSmall,
                ),
              ],
            ),
            content: const Text(
              'هل أنت تأكد من رغبتك في تسجيل الخروج من التطبيق؟',
              style: AppStyle.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  'إلغاء',
                  style: AppStyle.labelMedium.copyWith(color: AppColors.textMuted),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text(
                  'تأكيد',
                  style: AppStyle.buttonSmall,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final storage = getIt<FlutterSecureStorage>();
      await storage.deleteAll();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.coral),
          backgroundColor: AppColors.bgError,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_rounded, color: AppColors.coral, size: 20),
        label: Text(
          'تسجيل الخروج',
          style: AppStyle.buttonSmall.copyWith(
            color: AppColors.coral,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

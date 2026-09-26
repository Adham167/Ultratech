import 'package:flutter/material.dart';


import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import 'change_password_bottom_sheet.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({super.key});

  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangePasswordBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          backgroundColor: AppColors.bgLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showChangePasswordModal(context),
        icon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 20),
        label: Text(
          'تغيير كلمة السر',
          style: AppStyle.buttonSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

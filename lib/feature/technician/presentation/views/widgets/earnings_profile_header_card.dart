import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../Auth/data/models/response/user_profile_model.dart';
import 'earnings_profile_info_row.dart';

class EarningsProfileHeaderCard extends StatelessWidget {
  final UserProfileModel profile;

  const EarningsProfileHeaderCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.25),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName.isNotEmpty ? profile.fullName : 'المستخدم',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingSmall.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.roleName.isNotEmpty ? profile.roleName : 'موظف',
                      style: AppStyle.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: profile.isActive ? AppColors.bgSuccess : AppColors.bgError,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: profile.isActive
                        ? AppColors.borderSuccess
                        : AppColors.coral.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  profile.isActive ? 'نشط' : 'غير نشط',
                  style: AppStyle.labelSmall.copyWith(
                    color: profile.isActive ? AppColors.success : AppColors.coral,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.bgPage),
          EarningsProfileInfoRow(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: profile.phoneNumber),
          if (profile.email.isNotEmpty) ...[
            const SizedBox(height: 8),
            EarningsProfileInfoRow(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: profile.email),
          ],
          if (profile.areaName.isNotEmpty) ...[
            const SizedBox(height: 8),
            EarningsProfileInfoRow(icon: Icons.location_on_outlined, label: 'المنطقة', value: profile.areaName),
          ],
        ],
      ),
    );
  }
}

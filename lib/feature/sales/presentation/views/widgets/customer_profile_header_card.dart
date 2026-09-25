import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/customer_profile_model.dart';

class CustomerProfileHeaderCard extends StatelessWidget {
  final CustomerProfileModel profile;

  const CustomerProfileHeaderCard({
    super.key,
    required this.profile,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () => _makePhoneCall(profile.phoneNumber),
                icon: const Icon(Icons.call, size: 16),
                label:  Text('اتصال', style: AppStyle.buttonSmall.copyWith(color: AppColors.primary)),
              ),
              const Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingSmall.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.phoneNumber,
                      textDirection: TextDirection.ltr,
                      style: AppStyle.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.25),
                child: const Icon(Icons.person, size: 28, color: AppColors.primary),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.bgPage),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  '${profile.areaName} • ${profile.address}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodySmall,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text('الأجهزة المضافة', style: AppStyle.hint.copyWith(fontSize: 11)),
                      Text('${profile.devicesCount}', style: AppStyle.headingSmall.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text('الأوردرات السابقة', style: AppStyle.hint.copyWith(fontSize: 11)),
                      Text('${profile.ordersCount}', style: AppStyle.headingSmall.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

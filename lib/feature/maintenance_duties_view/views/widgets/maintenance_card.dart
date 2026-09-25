import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';

class MaintenanceCard extends StatelessWidget {
  final String customerName;
  final String address;
  final String area;
  final String phone;
  final String serviceType;
  final String dueDate;
  final VoidCallback? onCall;
  final VoidCallback? onPostpone;
  final VoidCallback? onApprove;

  const MaintenanceCard({
    super.key,
    required this.customerName,
    required this.address,
    required this.area,
    required this.phone,
    required this.serviceType,
    required this.dueDate,
    this.onCall,
    this.onPostpone,
    this.onApprove,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  area,
                  style: AppStyle.labelMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.textBody,
                  ),
                ),
              ),
              Text(
                customerName,
                style: AppStyle.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                address,
                style: AppStyle.bodySmall,
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: onCall ?? () => _makePhoneCall(phone),
                icon: const Icon(Icons.phone_outlined, size: 16, color: AppColors.primary),
                label: const Text(
                  'اتصال سريع',
                  style: AppStyle.buttonSmall,
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryLight),
                  backgroundColor: AppColors.bgPage,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  phone,
                  style: AppStyle.bodyMedium.copyWith(
                    color: AppColors.textBody,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      dueDate,
                      style: AppStyle.bodyMedium.copyWith(
                        color: AppColors.textBody,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  serviceType,
                  style: AppStyle.headingSmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPostpone,
                  icon: const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.coral),
                  label: Text(
                    'تأجيل / رفض',
                    style: AppStyle.buttonSmall.copyWith(color: AppColors.coral),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.coral),
                    backgroundColor: AppColors.bgError,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                  label: const Text(
                    'موافقة على الصيانة',
                    style: AppStyle.buttonSmall,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
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

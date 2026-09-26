import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../domain/entities/maintenance_assigned_entity.dart';

class MaintenanceCardWidget extends StatelessWidget {
  final MaintenanceAssignedEntity maintenance;
  final VoidCallback onDecisionTap;

  const MaintenanceCardWidget({
    super.key,
    required this.maintenance,
    required this.onDecisionTap,
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
      margin: const EdgeInsets.only(bottom: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDecisionBadge(maintenance.currentDecision),
              Text(
                maintenance.customerName,
                style: AppStyle.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(maintenance.customerPhone, style: AppStyle.bodySmall),
              const SizedBox(width: 8),
              const Icon(Icons.phone_outlined, size: 16, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  maintenance.customerAddress,
                  textAlign: TextAlign.right,
                  style: AppStyle.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
            ],
          ),
          const Divider(height: 24, color: AppColors.bgPage),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تاريخ الاستحقاق', style: AppStyle.hint.copyWith(fontSize: 10)),
                  Text(
                    maintenance.nextDueDate.toString().split(' ')[0],
                    style: AppStyle.labelSmall.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('الجهاز', style: AppStyle.hint.copyWith(fontSize: 10)),
                  Text(maintenance.deviceName, style: AppStyle.labelSmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makePhoneCall(maintenance.customerPhone),
                  icon: const Icon(Icons.call, size: 18),
                  label:  Text('اتصال', style: AppStyle.buttonSmall.copyWith(color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onDecisionTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('اتخاذ قرار', style: AppStyle.buttonSmall),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionBadge(int decision) {
    String text;
    Color color;
    switch (decision) {
      case 2:
        text = 'تمت الموافقة';
        color = AppColors.success;
        break;
      case 3:
        text = 'مؤجل';
        color = AppColors.warning;
        break;
      case 4:
        text = 'مرفوض';
        color = AppColors.coral;
        break;
      default:
        text = 'قيد التواصل';
        color = AppColors.sky;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppStyle.labelSmall.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

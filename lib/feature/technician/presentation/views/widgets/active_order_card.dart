import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';

class ActiveOrderCard extends StatelessWidget {
  final OrderModel? order;
  final String? customerName;
  final String? orderNumber;
  final String? address;
  final String? area;
  final String? phone;
  final String? time;
  final String? serviceType;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const ActiveOrderCard({
    super.key,
    this.order,
    this.customerName,
    this.orderNumber,
    this.address,
    this.area,
    this.phone,
    this.time,
    this.serviceType,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final displayArea = order?.areaName ?? area ?? 'التجمع الخامس';
    final displayOrderNum = order?.orderNumber ?? orderNumber ?? 'JO-8834';
    final displayName = order?.customerName ?? customerName ?? 'نور الدين';
    final displayAddress = order?.customerAddress ?? address ?? '23 كمبوند صان رايز، فيلا 5';
    final displayPhone = order?.customerPhone ?? phone ?? '0106 778 0221';
    final displayNotes = order?.notes ?? serviceType ?? 'التكييف لا يبرد — فحص وإصلاح';
    final displayTime = time ?? 'اليوم 2:00 - 4:00 مساءً';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        displayArea,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.labelMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'أوردر $displayOrderNum',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppStyle.headingSmall.copyWith(
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        displayAddress,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  displayPhone,
                  textDirection: TextDirection.ltr,
                  style: AppStyle.bodySmall,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.bgPage,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                displayTime,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.labelMedium.copyWith(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          displayNotes,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppStyle.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReject,
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 16,
                          color: AppColors.coral,
                        ),
                        label: Text(
                          'اعتذار / رفض',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.buttonSmall.copyWith(color: AppColors.coral),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.coral),
                          backgroundColor: AppColors.bgError,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'قبول الأوردر',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.buttonSmall,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

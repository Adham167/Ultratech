import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'التجمع الخامس',
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
                    'أوردر JO-8834',
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
                const Text(
                  'نور الدين',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingSmall,
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        '23 كمبوند صان رايز، فيلا 5',
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodySmall,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '0106 778 0221',
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
                                'اليوم 2:00 - 4:00 مساءً',
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
                      const Flexible(
                        child: Text(
                          'التكييف لا يبرد — فحص وإصلاح',
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
                        onPressed: () {},
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
                        onPressed: () {},
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

import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';
import '../../manager/orders_cubit/technician_orders_cubit.dart';
import 'complete_order_bottom_sheet.dart';

class OrderDetailsBottomActionBar extends StatelessWidget {
  final OrderModel order;
  final TechnicianOrdersCubit cubit;
  final bool isLoading;

  const OrderDetailsBottomActionBar({
    super.key,
    required this.order,
    required this.cubit,
    required this.isLoading,
  });

  Future<bool?> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required IconData icon,
  }) {
    return showDialog<bool>(
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
                Icon(icon, color: confirmColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.headingSmall,
                  ),
                ),
              ],
            ),
            content: Text(
              content,
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
                  backgroundColor: confirmColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  confirmText,
                  style: AppStyle.buttonSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCompleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return CompleteOrderBottomSheet(
          order: order,
          availableProducts: cubit.cachedProducts,
          onSubmit: (request) {
            Navigator.pop(modalContext);
            cubit.completeOrder(order.id, request);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = order.status;

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
        child: isLoading
            ? const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (status == 1 || order.statusText.contains('جديد'))
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmed = await _showConfirmDialog(
                            context: context,
                            title: 'تأكيد قبول الأوردر',
                            content: 'هل أنت تأكد من قبول هذا الأوردر وتحديث حالته؟',
                            confirmText: 'نعم، قبول',
                            confirmColor: AppColors.primary,
                            icon: Icons.check_circle_outline,
                          );
                          if (confirmed == true) {
                            cubit.acceptOrder(order.id);
                          }
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
                        label: const Text('قبول الأوردر', style: AppStyle.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),

                  if (status == 2 || order.statusText.contains('مقبول'))
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmed = await _showConfirmDialog(
                            context: context,
                            title: 'تأكيد بدء العمل',
                            content: 'هل أنت تأكد من تأكيد الوصول وبدء العمل على هذا الأوردر؟',
                            confirmText: 'نعم، بدء العمل',
                            confirmColor: AppColors.success,
                            icon: Icons.play_arrow_rounded,
                          );
                          if (confirmed == true) {
                            cubit.startOrder(order.id);
                          }
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 22, color: Colors.white),
                        label: const Text('تم الوصول / بدء العمل', style: AppStyle.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),

                  if (status == 3 || order.statusText.contains('جاري'))
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _showCompleteSheet(context),
                        icon: const Icon(Icons.receipt_long_rounded, size: 20, color: Colors.white),
                        label: const Text('إصدار الفاتورة وإنهاء العمل', style: AppStyle.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),

                  if (status == 4 || status == 5 || order.statusText.contains('مكتمل'))
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.bgSuccess,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSuccess),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'تم إنهاء العمل وتصدير الفاتورة (${order.totalAmount} ج.م)',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppStyle.labelMedium.copyWith(color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

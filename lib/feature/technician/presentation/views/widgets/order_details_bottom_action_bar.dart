import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';
import '../../manager/orders_cubit/technician_orders_cubit.dart';

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

  // =========================================================
  // Order Status
  // =========================================================

  bool get isAssigned {
    return order.status == 1 ||
        (order.status == 0 &&
            (order.statusText.toLowerCase().contains('assigned') ||
                order.statusText.toLowerCase().contains('new') ||
                order.statusText.contains('مسند') ||
                order.statusText.contains('جديد')));
  }

  bool get isAccepted {
    return order.status == 2 ||
        (order.status == 0 &&
            !isAssigned &&
            (order.statusText.toLowerCase().contains('accepted') ||
                order.statusText.toLowerCase().contains('intransit') ||
                order.statusText.contains('مقبول') ||
                order.statusText.contains('في الطريق')));
  }

  /// بعد الضغط على "تم الوصول" يصبح الأوردر في حالة العمل.
  ///
  /// مهم:
  /// في الـ API الحالي الحالة التي نحتاجها هنا هي 4.
  /// لذلك لا يجب اعتبار 4 completed.
  bool get isInProgress {
    final statusText = order.statusText.toLowerCase();

    return order.status == 3 ||
        order.status == 4 ||
        (order.status == 0 &&
            !isAssigned &&
            !isAccepted &&
            (statusText.contains('arrived') ||
                statusText.contains('inprogress') ||
                statusText.contains('in progress') ||
                order.statusText.contains('تم الوصول') ||
                order.statusText.contains('جاري') ||
                order.statusText.contains('قيد التنفيذ')));
  }

  /// الإنهاء الحقيقي يبدأ من status = 5.
  bool get isCompleted {
    final statusText = order.statusText.toLowerCase();

    return order.status >= 5 ||
        (order.status == 0 &&
            !isAssigned &&
            !isAccepted &&
            !isInProgress &&
            (statusText.contains('completed') ||
                statusText.contains('complete') ||
                order.statusText.contains('مكتمل') ||
                order.statusText.contains('منتهي') ||
                order.statusText.contains('تم الإنهاء')));
  }

  // =========================================================
  // Confirmation Dialog
  // =========================================================

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
            content: Text(content, style: AppStyle.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: Text(
                  'إلغاء',
                  style: AppStyle.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
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
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: Text(confirmText, style: AppStyle.buttonSmall),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // Navigate To Invoice
  // =========================================================

  Future<void> _navigateToCompleteScreen(BuildContext context) async {
    debugPrint(
      'DEBUG: Navigating to CompleteOrderScreen '
      'for orderId=${order.id}',
    );

    await context.push(AppRouter.kCompleteOrderScreen, extra: order);

    if (!context.mounted) {
      return;
    }

    debugPrint(
      'DEBUG: Returned from CompleteOrderScreen '
      'for orderId=${order.id}',
    );

    await context.read<TechnicianOrdersCubit>().getMyOrders(showLoading: false);
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final status = order.status;

    debugPrint(
      'DEBUG: OrderDetailsBottomActionBar '
      'orderId=${order.id}, '
      'status=$status, '
      'statusText=${order.statusText}, '
      'isAssigned=$isAssigned, '
      'isAccepted=$isAccepted, '
      'isInProgress=$isInProgress, '
      'isCompleted=$isCompleted',
    );

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
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // =====================================================
                  // 1. Assigned -> Accept
                  // =====================================================
                  if (isAssigned)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmed = await _showConfirmDialog(
                            context: context,
                            title: 'تأكيد قبول الأوردر',
                            content:
                                'هل أنت متأكد من قبول هذا الأوردر وتحديث حالته؟',
                            confirmText: 'نعم، قبول',
                            confirmColor: AppColors.primary,
                            icon: Icons.check_circle_outline,
                          );

                          if (confirmed == true) {
                            await cubit.acceptOrder(order.id);
                          }
                        },
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text('قبول الطلب', style: AppStyle.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    )
                  // =====================================================
                  // 2. Accepted -> Arrived
                  // =====================================================
                  else if (isAccepted)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmed = await _showConfirmDialog(
                            context: context,
                            title: 'تأكيد الوصول للمكان',
                            content:
                                'هل أنت متأكد من تأكيد الوصول وبدء العمل على هذا الأوردر؟',
                            confirmText: 'نعم، تم الوصول',
                            confirmColor: AppColors.success,
                            icon: Icons.location_on_rounded,
                          );

                          if (confirmed == true) {
                            await cubit.startOrder(order.id);
                          }
                        },
                        icon: const Icon(
                          Icons.location_on_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: const Text('تم الوصول', style: AppStyle.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    )
                  // =====================================================
                  // 3. In Progress -> Invoice
                  // =====================================================
                  else if (isInProgress)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _navigateToCompleteScreen(context);
                        },
                        icon: const Icon(
                          Icons.receipt_long_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'إصدار الفاتورة وإنهاء العمل',
                          style: AppStyle.button,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    )
                  // =====================================================
                  // 4. Completed
                  // =====================================================
                  else if (isCompleted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSuccess,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSuccess),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'تم إنهاء العمل وإصدار الفاتورة '
                              '(${order.totalAmount} ج.م)',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppStyle.labelMedium.copyWith(
                                color: AppColors.success,
                              ),
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

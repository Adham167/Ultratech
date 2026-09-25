import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class OrderSuccessDialogWidget extends StatelessWidget {
  final String orderNumber;
  final String customerName;
  final num totalAmount;
  final VoidCallback? onViewDetails;
  final VoidCallback? onClose;

  const OrderSuccessDialogWidget({
    super.key,
    required this.orderNumber,
    required this.customerName,
    required this.totalAmount,
    this.onViewDetails,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.bgCard,
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.bgSuccess,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'تم إنشاء الأوردر بنجاح 🎉',
              textAlign: TextAlign.center,
              style: AppStyle.headingMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildDialogDetailRow(
                    'رقم الأوردر',
                    orderNumber.isNotEmpty ? orderNumber : 'قيد التجهيز',
                  ),
                  const Divider(height: 16, color: AppColors.borderSubtle),
                  _buildDialogDetailRow(
                    'اسم العميل',
                    customerName.isNotEmpty ? customerName : 'عميل مسجل',
                  ),
                  const Divider(height: 16, color: AppColors.borderSubtle),
                  _buildDialogDetailRow(
                    'إجمالي الفاتورة',
                    '$totalAmount ج.م',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (onViewDetails != null) {
                    onViewDetails!();
                  } else {
                    context.pop();
                  }
                },
                child: const Text('عرض تفاصيل الأوردر', style: AppStyle.buttonSmall),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onClose != null) {
                    onClose!();
                  } else {
                    context.pop();
                  }
                },
                child: Text(
                  'إغلاق / العودة',
                  style: AppStyle.labelMedium.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: AppStyle.labelMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppStyle.hint,
        ),
      ],
    );
  }
}

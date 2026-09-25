import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';

class CustomerProfileBottomBar extends StatelessWidget {
  final int customerId;
  final String customerName;

  const CustomerProfileBottomBar({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              context.push(
                AppRouter.kCreateOrderView,
                extra: {
                  'customerId': customerId,
                  'customerName': customerName,
                },
              );
            },
            icon: const Icon(Icons.add_shopping_cart, size: 20, color: Colors.white),
            label: const Text('إنشاء أوردر جديد', style: AppStyle.button),
          ),
        ),
      ),
    );
  }
}

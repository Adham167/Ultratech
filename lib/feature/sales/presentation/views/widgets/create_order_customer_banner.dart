import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class CreateOrderCustomerBanner extends StatelessWidget {
  final int customerId;
  final String customerName;

  const CreateOrderCustomerBanner({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'أوردر مخصص للعميل',
                  style: TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  customerName.isNotEmpty ? customerName : 'عميل رقم #$customerId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

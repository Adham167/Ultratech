import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../technician/data/models/order_model.dart';

class SalesOrderDetailsCustomerCard extends StatelessWidget {
  final OrderModel order;

  const SalesOrderDetailsCustomerCard({
    super.key,
    required this.order,
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
              const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text('بيانات العميل والفني', style: AppStyle.headingSmall),
            ],
          ),
          const Divider(height: 20, color: AppColors.bgPage),
          _buildRow('اسم العميل', order.customerName),
          if (order.customerPhone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    onPressed: () => _makePhoneCall(order.customerPhone),
                    icon: const Icon(Icons.call, size: 16),
                    label:  Text('اتصال', style: AppStyle.buttonSmall.copyWith(color: AppColors.primary)),
                  ),
                  const Spacer(),
                  Text(order.customerPhone, textDirection: TextDirection.ltr, style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Text('الهاتف', style: AppStyle.hint),
                ],
              ),
            ),
          _buildRow('العنوان', order.customerAddress),
          _buildRow('المنطقة', order.areaName),
          if (order.technicianName.isNotEmpty)
            _buildRow('الفني المسند إليه', order.technicianName),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: AppStyle.hint),
        ],
      ),
    );
  }
}

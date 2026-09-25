import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';
import 'order_details_info_row.dart';
import 'order_details_section_card.dart';

class OrderDetailsCustomerCard extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsCustomerCard({
    super.key,
    required this.order,
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
    return OrderDetailsSectionCard(
      title: 'بيانات العميل',
      icon: Icons.person_outline,
      child: Column(
        children: [
          OrderDetailsInfoRow(
            icon: Icons.person_outline,
            label: 'الاسم',
            value: order.customerName.isNotEmpty ? order.customerName : 'غير متوفر',
          ),
          if (order.customerPhone.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    onPressed: () => _makePhoneCall(order.customerPhone),
                    icon: const Icon(Icons.call, size: 16),
                    label: const Text('اتصال', style: AppStyle.buttonSmall),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      order.customerPhone,
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.phone_outlined, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  const Text('الهاتف', style: AppStyle.hint),
                ],
              ),
            ),
          ],
          OrderDetailsInfoRow(
            icon: Icons.location_on_outlined,
            label: 'العنوان',
            value: order.customerAddress.isNotEmpty ? order.customerAddress : 'غير مدخل',
          ),
          if (order.areaName.isNotEmpty)
            OrderDetailsInfoRow(
              icon: Icons.map_outlined,
              label: 'المنطقة',
              value: order.areaName,
            ),
        ],
      ),
    );
  }
}

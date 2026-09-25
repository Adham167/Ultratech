import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';
import 'order_details_info_row.dart';
import 'order_details_section_card.dart';

class OrderDetailsInfoCard extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsInfoCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return OrderDetailsSectionCard(
      title: 'تفاصيل الخدمة والصيانة',
      icon: Icons.build_outlined,
      child: Column(
        children: [
          OrderDetailsInfoRow(
            icon: Icons.design_services_outlined,
            label: 'نوع الخدمة',
            value: order.typeText.isNotEmpty ? order.typeText : 'خدمة صيانة ومتابعة',
          ),
          OrderDetailsInfoRow(
            icon: Icons.description_outlined,
            label: 'الملاحظات / العطل',
            value: order.notes != null && order.notes!.isNotEmpty
                ? order.notes!
                : 'لا توجد ملاحظات إضافية',
          ),
          if (order.technicianName.isNotEmpty)
            OrderDetailsInfoRow(
              icon: Icons.badge_outlined,
              label: 'الفني المسؤول',
              value: order.technicianName,
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../core/utils/app_style.dart';
import 'active_order_card.dart';
import 'waiting_order_card.dart';

class TechnicianOrdersViewBody extends StatelessWidget {
  const TechnicianOrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              'أوردرات العمل',
              style: AppStyle.headingLarge,
            ),
            SizedBox(height: 4),
            Text(
              'المهام الواردة المسندة إليك.',
              style: AppStyle.bodySmall,
            ),
            SizedBox(height: 16),
            ActiveOrderCard(),
            SizedBox(height: 20),
            Text(
              'التالي في الانتظار',
              style: AppStyle.labelMedium,
            ),
            SizedBox(height: 8),
            WaitingOrderCard(
              customerName: 'ليلى سامي',
              serviceType: 'تركيب سخان',
              time: '4:30 مساءً',
              area: 'الزمالك',
            ),
          ],
        ),
      ),
    );
  }
}

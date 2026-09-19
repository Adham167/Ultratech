import 'package:flutter/material.dart';
import 'maintenance_header.dart';
import 'maintenance_card.dart';

class MaintenanceDutiesViewBody extends StatelessWidget {
  const MaintenanceDutiesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            MaintenanceHeader(),
            SizedBox(height: 16),
            MaintenanceCard(
              customerName: 'أميرة حسن',
              address: '12 كمبوند بالم ريزيدنس، بلوك C',
              area: 'التجمع الخامس',
              phone: '0100 442 0889',
              serviceType: 'صيانة تكييف ربع سنوية',
              dueDate: '18 سبتمبر 2026',
            ),
            SizedBox(height: 12),
            MaintenanceCard(
              customerName: 'يوسف عادل',
              address: '44 أبراج نايل فيو، شقة 9',
              area: 'المعادي',
              phone: '0101 220 7745',
              serviceType: 'فحص سخان المياه',
              dueDate: '19 سبتمبر 2026',
            ),
            SizedBox(height: 12),
            MaintenanceCard(
              customerName: 'سلمى فاروق',
              address: '7 كمبوند جرين أوازيس',
              area: '6 أكتوبر',
              phone: '0128 990 1234',
              serviceType: 'صيانة الدائرة الكهربائية',
              dueDate: '20 سبتمبر 2026',
            ),
          ],
        ),
      ),
    );
  }
}

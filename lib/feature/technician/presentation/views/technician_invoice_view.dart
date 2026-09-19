import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'widgets/technician_invoice_view_body.dart';

class TechnicianInvoiceView extends StatelessWidget {
  const TechnicianInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPage,
      body: TechnicianInvoiceViewBody(),
    );
  }
}

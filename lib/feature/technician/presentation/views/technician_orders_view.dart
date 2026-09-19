import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'widgets/technician_orders_view_body.dart';

class TechnicianOrdersView extends StatelessWidget {
  const TechnicianOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPage,
      body: TechnicianOrdersViewBody(),
    );
  }
}

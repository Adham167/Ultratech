import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import 'widgets/maintenance_duties_view_body.dart';

class MaintenanceDutiesView extends StatelessWidget {
  const MaintenanceDutiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPage,
      body: MaintenanceDutiesViewBody(),
    );
  }
}

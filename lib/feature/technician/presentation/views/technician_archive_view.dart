import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'widgets/technician_archive_view_body.dart';

class TechnicianArchiveView extends StatelessWidget {
  const TechnicianArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPage,
      body: TechnicianArchiveViewBody(),
    );
  }
}

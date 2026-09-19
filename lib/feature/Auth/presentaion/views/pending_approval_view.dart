import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import 'widgets/pending_approval_view_body.dart';

class PendingApprovalView extends StatelessWidget {
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgPage,
      body: PendingApprovalViewBody(),
    );
  }
}

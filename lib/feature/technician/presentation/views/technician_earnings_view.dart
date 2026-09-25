import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/earnings_cubit/technician_earnings_cubit.dart';
import 'widgets/technician_earnings_view_body.dart';

class TechnicianEarningsView extends StatelessWidget {
  const TechnicianEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      getIt<TechnicianEarningsCubit>()..getMyEarnings(),
      child: const Scaffold(
        backgroundColor: AppColors.bgPage,
        body: TechnicianEarningsViewBody(),
      ),
    );
  }
}
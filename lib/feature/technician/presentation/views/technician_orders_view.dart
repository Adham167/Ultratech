import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/orders_cubit/technician_orders_cubit.dart';
import 'widgets/technician_orders_view_body.dart';

class TechnicianOrdersView extends StatelessWidget {
  const TechnicianOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TechnicianOrdersCubit>(),
      child: const Scaffold(
        backgroundColor: AppColors.bgPage,
        body: TechnicianOrdersViewBody(),
      ),
    );
  }
}

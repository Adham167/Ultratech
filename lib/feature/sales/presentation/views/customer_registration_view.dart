import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/customer_registration_cubit.dart';
import 'widgets/sales_customer_onboarding_view_body.dart';

class CustomerRegistrationView extends StatelessWidget {
  const CustomerRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CustomerRegistrationCubit>(),
      child: const Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SalesCustomerOnboardingViewBody(),
      ),
    );
  }
}

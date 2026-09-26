import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/customer_profile_cubit.dart';
import '../manager/customer_profile_state.dart';
import 'widgets/customer_profile_bottom_bar.dart';
import 'widgets/customer_profile_header_card.dart';
import 'widgets/customer_profile_orders_card.dart';

class CustomerProfileView extends StatefulWidget {
  final int customerId;

  const CustomerProfileView({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  late final CustomerProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CustomerProfileCubit>();
    _cubit.getCustomerProfile(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: AppBar(
          backgroundColor: AppColors.bgPage,
          elevation: 0,
          centerTitle: true,
          title: const Text('البروفايل الكامل للعميل', style: AppStyle.headingMedium),
        ),
        body: BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
          builder: (context, state) {
            if (state is CustomerProfileLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is CustomerProfileFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.coral),
                    const SizedBox(height: 12),
                    Text(state.errMessage, style: AppStyle.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.getCustomerProfile(widget.customerId),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('إعادة المحاولة', style: AppStyle.buttonSmall),
                    ),
                  ],
                ),
              );
            }

            if (state is CustomerProfileSuccess) {
              final profile = state.profile;
              return Scaffold(
                backgroundColor: AppColors.bgPage,
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        CustomerProfileHeaderCard(profile: profile),
                        const SizedBox(height: 16),
                        // CustomerProfileDevicesCard(devices: profile.devices),
                        // const SizedBox(height: 16),
                        CustomerProfileOrdersCard(orders: profile.orders),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: CustomerProfileBottomBar(
                  customerId: profile.id,
                  customerName: profile.fullName,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

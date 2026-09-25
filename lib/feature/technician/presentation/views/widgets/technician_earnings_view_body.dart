import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../Auth/data/models/response/user_profile_model.dart';
import '../../../data/models/earnings_model.dart';
import '../../manager/earnings_cubit/technician_earnings_cubit.dart';
import '../../manager/earnings_cubit/technician_earnings_state.dart';
import 'earnings_amount_card.dart';
import 'earnings_commission_card.dart';
import 'earnings_failure_state.dart';
import 'earnings_logout_button.dart';
import 'earnings_orders_card.dart';
import 'earnings_profile_header_card.dart';
import 'earnings_salary_card.dart';

class TechnicianEarningsViewBody extends StatelessWidget {
  const TechnicianEarningsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<TechnicianEarningsCubit, TechnicianEarningsState>(
        listener: (context, state) {
          if (state is TechnicianEarningsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errMessage,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
                backgroundColor: AppColors.coral,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TechnicianEarningsLoading ||
              state is TechnicianEarningsInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is TechnicianEarningsFailure) {
            return EarningsFailureState(
              errMessage: state.errMessage,
              onRetry: () => context.read<TechnicianEarningsCubit>().getMyEarnings(),
            );
          }

          if (state is TechnicianEarningsSuccess) {
            return _buildContent(
              context,
              state.earnings,
              state.profile,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    EarningsModel earnings,
    UserProfileModel? profile,
  ) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () {
        return context.read<TechnicianEarningsCubit>().getMyEarnings();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'البروفايل والأرباح',
              style: AppStyle.headingLarge,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 4),
            const Text(
              'بيانات حسابك الشخصي ومتابعة راتبك واستحقاقاتك.',
              style: AppStyle.bodyMedium,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),

            if (profile != null) ...[
              EarningsProfileHeaderCard(profile: profile),
              const SizedBox(height: 20),
            ],

            EarningsSalaryCard(baseSalary: earnings.baseSalary),
            const SizedBox(height: 16),
            EarningsCommissionCard(commissionRate: earnings.commissionRate),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: EarningsAmountCard(
                    title: 'المدفوعة',
                    amount: earnings.paidCommissionsAmount,
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.success,
                    backgroundColor: AppColors.bgSuccess,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EarningsAmountCard(
                    title: 'المؤكدة',
                    amount: earnings.confirmedUnpaidCommissionsAmount,
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.bgLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            EarningsAmountCard(
              title: 'العمولات المعلقة',
              amount: earnings.pendingCommissionsAmount,
              icon: Icons.pending_actions,
              iconColor: AppColors.warning,
              backgroundColor: AppColors.bgWarning,
            ),
            const SizedBox(height: 16),
            EarningsOrdersCard(totalOrdersCompleted: earnings.totalOrdersCompleted),
            const SizedBox(height: 24),
            const EarningsLogoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

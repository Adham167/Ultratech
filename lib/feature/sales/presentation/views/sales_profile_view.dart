import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../Auth/presentaion/views/widgets/change_password_button.dart';
import '../../../technician/presentation/manager/earnings_cubit/technician_earnings_cubit.dart';
import '../../../technician/presentation/manager/earnings_cubit/technician_earnings_state.dart';
import '../../../profile/presentation/views/widgets/profile_amount_card.dart';
import '../../../profile/presentation/views/widgets/profile_commission_card.dart';
import '../../../profile/presentation/views/widgets/profile_failure_state.dart';
import '../../../profile/presentation/views/widgets/profile_logout_button.dart';
import '../../../profile/presentation/views/widgets/profile_orders_card.dart';
import '../../../profile/presentation/views/widgets/profile_header_card.dart';
import '../../../profile/presentation/views/widgets/profile_salary_card.dart';

class SalesProfileView extends StatefulWidget {
  final TabController? controller;
  const SalesProfileView({super.key, this.controller});

  @override
  State<SalesProfileView> createState() => _SalesProfileViewState();
}

class _SalesProfileViewState extends State<SalesProfileView>
    with AutomaticKeepAliveClientMixin {
  late final TechnicianEarningsCubit _earningsCubit;
  bool _isDataFetched = false;

  @override
  void initState() {
    super.initState();
    _earningsCubit = getIt<TechnicianEarningsCubit>();

    if (widget.controller != null) {
      widget.controller!.addListener(_handleTabSelection);
    } else {
      _isDataFetched = true;
      _earningsCubit.getMyEarnings();
    }

    if (widget.controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleTabSelection();
      });
    }
  }

  void _handleTabSelection() {
    if (!mounted || widget.controller == null) return;

    if (widget.controller!.index == 2 &&
        !_isDataFetched &&
        !widget.controller!.indexIsChanging) {
      setState(() {
        _isDataFetched = true;
      });
      _earningsCubit.getMyEarnings();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTabSelection);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _earningsCubit,
      child: Scaffold(
          backgroundColor: AppColors.bgPage,
          body: const SalesProfileViewBody()),
    );
  }
}

class SalesProfileViewBody extends StatelessWidget {
  const SalesProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<TechnicianEarningsCubit, TechnicianEarningsState>(
        listener: (context, state) {
          if (state is TechnicianEarningsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: AppColors.coral,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TechnicianEarningsLoading || state is TechnicianEarningsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is TechnicianEarningsFailure) {
            return ProfileFailureState(
              errMessage: state.errMessage,
              onRetry: () => context.read<TechnicianEarningsCubit>().getMyEarnings(),
            );
          }

          if (state is TechnicianEarningsSuccess) {
            final earnings = state.earnings;
            final profile = state.profile;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<TechnicianEarningsCubit>().getMyEarnings(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'البروفايل والأرباح (المبيعات)',
                      style: AppStyle.headingLarge,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'بيانات حسابك الشخصي ومتابعة مبيعاتك وعمولاتك.',
                      style: AppStyle.bodySmall,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 20),
                    if (profile != null) ...[
                      ProfileHeaderCard(profile: profile),
                      const SizedBox(height: 20),
                    ],
                    ProfileSalaryCard(baseSalary: earnings.baseSalary),
                    const SizedBox(height: 16),
                    ProfileCommissionCard(commissionRate: earnings.commissionRate),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ProfileAmountCard(
                            title: 'المدفوعة',
                            amount: earnings.paidCommissionsAmount,
                            icon: Icons.payments_outlined,
                            iconColor: AppColors.success,
                            backgroundColor: AppColors.bgSuccess,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ProfileAmountCard(
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
                    ProfileAmountCard(
                      title: 'العمولات المعلقة',
                      amount: earnings.pendingCommissionsAmount,
                      icon: Icons.pending_actions,
                      iconColor: AppColors.warning,
                      backgroundColor: AppColors.bgWarning,
                    ),
                    const SizedBox(height: 16),
                    ProfileOrdersCard(totalOrdersCompleted: earnings.totalOrdersCompleted),
                    const SizedBox(height: 24),
                    const ChangePasswordButton(),
                    const SizedBox(height: 12),
                    const ProfileLogoutButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

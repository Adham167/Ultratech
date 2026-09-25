import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ultra_tech/feature/sales/presentation/views/maintenance_tab_view.dart';
import 'package:ultra_tech/feature/sales/presentation/views/sales_customer_onboarding_view.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/sales_dashboard_cubit.dart';
import '../manager/sales_dashboard_state.dart';

class SalesDashboardView extends StatefulWidget {
  const SalesDashboardView({super.key});

  @override
  State<SalesDashboardView> createState() => _SalesDashboardViewState();
}

class _SalesDashboardViewState extends State<SalesDashboardView>
    with SingleTickerProviderStateMixin {
  late final SalesDashboardCubit _dashboardCubit;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = getIt<SalesDashboardCubit>()..getProfile();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: 120,
          flexibleSpace: const SalesDashboardHeader(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.bgPage,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: AppStyle.labelMedium,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'الصيانة الدورية'),
                  Tab(text: 'تسجيل العملاء'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MaintenanceTabView(controller: _tabController),
            SalesCustomerOnboardingView(tabController: _tabController),
          ],
        ),
      ),
    );
  }
}

class SalesDashboardHeader extends StatelessWidget {
  const SalesDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesDashboardCubit, SalesDashboardState>(
      builder: (context, state) {
        if (state is SalesDashboardLoading) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (state is SalesDashboardFailure) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('خطأ في تحميل البيانات',
                    style: TextStyle(color: Colors.white)),
                IconButton(
                  onPressed: () =>
                      context.read<SalesDashboardCubit>().getProfile(),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          );
        }
        if (state is SalesDashboardSuccess) {
          final agent = state.agent;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'عمولة: ${(agent.commissionRate * 100).toInt()}%',
                        style:
                            AppStyle.bodySmall.copyWith(color: Colors.white70),
                      ),
                      Text(
                        '${agent.baseSalary.toInt()} ج.م',
                        style:
                            AppStyle.labelMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'أهلاً، ${agent.fullName}',
                        style:
                            AppStyle.headingSmall.copyWith(color: Colors.white),
                      ),
                      Text(
                        agent.areaName,
                        style:
                            AppStyle.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

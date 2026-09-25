import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../manager/maintenance_cubit.dart';
import '../../manager/maintenance_state.dart';
import '../../widgets/decision_bottom_sheet.dart';
import '../../widgets/maintenance_card_widget.dart';

class MaintenanceTabBody extends StatelessWidget {
  const MaintenanceTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaintenanceCubit, MaintenanceState>(
      listener: (context, state) {
        if (state is MaintenanceDecisionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is MaintenanceDecisionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errMessage,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: AppColors.coral,
            ),
          );
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'قائمة الصيانة الدورية',
                    textAlign: TextAlign.right,
                    style: AppStyle.headingLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'المهام الروتينية المسندة إليك للمتابعة.',
                    textAlign: TextAlign.right,
                    style: AppStyle.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<MaintenanceCubit, MaintenanceState>(
                  builder: (context, state) {
                    if (state is MaintenanceLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    } else if (state is MaintenanceSuccess) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () =>
                            context.read<MaintenanceCubit>().getAssignedMaintenance(),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.maintenanceList.length,
                          itemBuilder: (context, index) {
                            final item = state.maintenanceList[index];
                            return MaintenanceCardWidget(
                              maintenance: item,
                              onDecisionTap: () => _showDecisionSheet(context, item.id),
                            );
                          },
                        ),
                      );
                    } else if (state is MaintenanceEmpty) {
                      return _buildEmptyState(context);
                    } else if (state is MaintenanceFailure) {
                      return _buildErrorState(context, state.errMessage);
                    } else if (state is MaintenanceInitial) {
                      return const Center(
                        child: Text(
                          "يرجى الضغط للبدء...",
                          style: AppStyle.bodyMedium,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: AppColors.textMuted.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا يوجد مهام صيانة مُسندة لك حالياً',
              style: AppStyle.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  context.read<MaintenanceCubit>().getAssignedMaintenance(),
              child: const Text('تحديث القائمة', style: AppStyle.labelMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.coral),
          const SizedBox(height: 16),
          Text(message, style: AppStyle.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () =>
                context.read<MaintenanceCubit>().getAssignedMaintenance(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('إعادة المحاولة', style: AppStyle.buttonSmall),
          ),
        ],
      ),
    );
  }

  void _showDecisionSheet(BuildContext context, int id) {
    final cubit = context.read<MaintenanceCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DecisionBottomSheet(
        maintenanceId: id,
        onSubmit: (params) => cubit.submitDecision(params),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';
import '../../manager/orders_cubit/technician_orders_cubit.dart';
import '../../manager/orders_cubit/technician_orders_state.dart';
import 'technician_order_card.dart';

class TechnicianOrdersViewBody extends StatefulWidget {
  const TechnicianOrdersViewBody({super.key});

  @override
  State<TechnicianOrdersViewBody> createState() =>
      _TechnicianOrdersViewBodyState();
}

class _TechnicianOrdersViewBodyState
    extends State<TechnicianOrdersViewBody> {
  int? _selectedStatus; // null: الكل, 1: جديد, 3: جاري العمل, 4: مكتملة

  @override
  void initState() {
    super.initState();

    final cubit = context.read<TechnicianOrdersCubit>();
    cubit.getMyOrders();
    cubit.getProducts();
  }

  void _onFilterTabSelected(int? status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    if (_selectedStatus == null) {
      return orders;
    }

    return orders.where((order) {
      switch (_selectedStatus) {
        case 1:
          return order.status == 1;

        case 3:
          return order.status == 2 || order.status == 3;

        case 4:
          return order.status == 4 || order.status == 5;

        default:
          return true;
      }
    }).toList();
  }

  String _sanitizeErrorMessage(String rawMessage) {
    final msg = rawMessage.trim();

    if (msg.isEmpty ||
        msg.length > 80 ||
        msg.contains('{') ||
        msg.contains('}') ||
        msg.contains('Exception') ||
        msg.contains('DioError') ||
        msg.contains('HTML') ||
        msg.contains('Http') ||
        msg.contains('500') ||
        msg.contains('400')) {
      return 'حدث خطأ، يرجى المحاولة مرة أخرى';
    }

    return msg.replaceAll('\n', ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TechnicianOrdersCubit, TechnicianOrdersState>(
        builder: (context, state) {
          final cubit = context.read<TechnicianOrdersCubit>();
          final rawOrders = cubit.cachedOrders;
          final orders = _filterOrders(rawOrders);

          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getMyOrders(
                showLoading: false,
              );
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'أوردرات العمل',
                    style: AppStyle.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'المهام الواردة والمسندة إليك.',
                    style: AppStyle.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Status Filter Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildFilterTab(
                          label: 'المكتملة',
                          statusValue: 4,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterTab(
                          label: 'جاري العمل',
                          statusValue: 3,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterTab(
                          label: 'جديد',
                          statusValue: 1,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterTab(
                          label: 'الكل',
                          statusValue: null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Content Area
                  if (state is TechnicianOrdersLoading && rawOrders.isEmpty)
                    const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  else if (state is TechnicianOrdersFailure && rawOrders.isEmpty)
                    SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppColors.coral,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _sanitizeErrorMessage(
                                state.errMessage,
                              ),
                              style: AppStyle.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => cubit.getMyOrders(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text(
                                'إعادة المحاولة',
                                style: AppStyle.buttonSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (orders.isEmpty)
                    SizedBox(
                      height: 280,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inbox_outlined,
                              size: 56,
                              color: AppColors.borderDisabled,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'لا توجد أوردرات في هذه القائمة حالياً',
                              style: AppStyle.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        return TechnicianOrderCard(
                          order: order,
                          onTap: () {
                            context.push(
                              AppRouter.kTechnicianOrderDetailsView,
                              extra: order,
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required int? statusValue,
  }) {
    final isSelected = _selectedStatus == statusValue;

    return GestureDetector(
      onTap: () => _onFilterTabSelected(statusValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: AppStyle.labelMedium.copyWith(
            fontSize: 13,
            color: isSelected
                ? Colors.white
                : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

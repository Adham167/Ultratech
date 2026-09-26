import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../../data/models/order_model.dart';
import '../manager/location_cubit/location_cubit.dart';
import '../manager/location_cubit/location_state.dart';
import '../manager/orders_cubit/technician_orders_cubit.dart';
import '../manager/orders_cubit/technician_orders_state.dart';
import 'widgets/order_details_billing_summary_card.dart';
import 'widgets/order_details_bottom_action_bar.dart';
import 'widgets/order_details_customer_card.dart';
import 'widgets/order_details_info_card.dart';
import 'widgets/order_details_location_card.dart';
import 'widgets/order_details_spare_parts_card.dart';
import 'widgets/order_details_status_header.dart';

class TechnicianOrderDetailsView extends StatefulWidget {
  final OrderModel order;

  const TechnicianOrderDetailsView({super.key, required this.order});

  @override
  State<TechnicianOrderDetailsView> createState() =>
      _TechnicianOrderDetailsViewState();
}

class _TechnicianOrderDetailsViewState
    extends State<TechnicianOrderDetailsView> {
  late OrderModel _currentOrder;

  @override
  void initState() {
    super.initState();

    _currentOrder = widget.order;

    debugPrint(
      'DEBUG: TechnicianOrderDetailsView initialized '
      'Order ID = ${_currentOrder.id}, '
      'Status ID = ${_currentOrder.status}, '
      'Status Text = ${_currentOrder.statusText}',
    );
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

  String _getSuccessMessage(TechnicianActionSuccess state) {
    switch (state.actionType) {
      case 'accept':
        return 'تم قبول الأوردر بنجاح';

      case 'start':
        return 'تم بدء العمل على الأوردر';

      case 'complete':
        return 'تم إنهاء الأوردر وإصدار الفاتورة بنجاح';

      default:
        return 'تمت العملية بنجاح';
    }
  }

  void _updateCurrentOrderFromCache(TechnicianOrdersCubit cubit) {
    final updatedOrder = cubit.cachedOrders.cast<OrderModel?>().firstWhere(
      (order) => order?.id == _currentOrder.id,
      orElse: () => null,
    );

    if (updatedOrder != null && mounted) {
      setState(() {
        _currentOrder = updatedOrder;
      });

      debugPrint(
        'DEBUG: Updated local order '
        'status = ${_currentOrder.status}, '
        'statusText = ${_currentOrder.statusText}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'DEBUG: _currentOrder.status = ${_currentOrder.status}, '
      'statusText = ${_currentOrder.statusText}',
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<TechnicianOrdersCubit>()),
        BlocProvider(create: (_) => getIt<LocationCubit>()),
      ],
      child: BlocListener<LocationCubit, LocationState>(
        listener: (context, locState) async {
          debugPrint(
            'DEBUG: LocationState emitted: '
            '${locState.runtimeType}',
          );

          if (locState is LocationSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  locState.message.isNotEmpty
                      ? locState.message
                      : 'تم تحديث موقع العميل بنجاح.',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: AppColors.success,
              ),
            );

            final ordersCubit = context.read<TechnicianOrdersCubit>();

            await ordersCubit.getMyOrders(
              status: ordersCubit.currentStatusFilter,
              showLoading: false,
            );

            if (!mounted) {
              return;
            }

            _updateCurrentOrderFromCache(ordersCubit);
          }
        },
        child: BlocConsumer<TechnicianOrdersCubit, TechnicianOrdersState>(
          listener: (context, state) {
            debugPrint(
              'DEBUG: New State emitted: '
              '${state.runtimeType}',
            );

            if (state is TechnicianActionSuccess &&
                state.orderId == _currentOrder.id) {
              debugPrint(
                'DEBUG: TechnicianActionSuccess received '
                'for orderId = ${state.orderId}, '
                'actionType = ${state.actionType}',
              );

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _getSuccessMessage(state),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );

              final cubit = context.read<TechnicianOrdersCubit>();

              _updateCurrentOrderFromCache(cubit);
            } else if (state is TechnicianActionFailure) {
              debugPrint(
                'DEBUG: TechnicianActionFailure received: '
                '${state.errMessage}',
              );

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _sanitizeErrorMessage(state.errMessage),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: AppColors.coral,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<TechnicianOrdersCubit>();

            final isActionLoading =
                state is TechnicianActionLoading &&
                state.orderId == _currentOrder.id;

            return Scaffold(
              backgroundColor: AppColors.bgPage,
              appBar: AppBar(
                backgroundColor: AppColors.bgPage,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'تفاصيل الأوردر',
                  style: AppStyle.headingMedium,
                ),
              ),
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderDetailsStatusHeader(order: _currentOrder),
                      const SizedBox(height: 14),
                      OrderDetailsCustomerCard(order: _currentOrder),
                      const SizedBox(height: 14),
                      OrderDetailsLocationCard(order: _currentOrder),
                      const SizedBox(height: 14),
                      OrderDetailsInfoCard(order: _currentOrder),
                      const SizedBox(height: 14),
                      if (_currentOrder.items.isNotEmpty) ...[
                        OrderDetailsSparePartsCard(items: _currentOrder.items),
                        const SizedBox(height: 14),
                      ],
                      OrderDetailsBillingSummaryCard(
                        totalAmount: _currentOrder.totalAmount,
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: OrderDetailsBottomActionBar(
                order: _currentOrder,
                cubit: cubit,
                isLoading: isActionLoading,
              ),
            );
          },
        ),
      ),
    );
  }
}

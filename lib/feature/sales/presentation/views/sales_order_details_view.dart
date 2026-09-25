import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/sales_order_details_cubit.dart';
import '../manager/sales_order_details_state.dart';
import 'widgets/sales_order_details_customer_card.dart';
import 'widgets/sales_order_details_header.dart';
import 'widgets/sales_order_details_items_card.dart';

class SalesOrderDetailsView extends StatefulWidget {
  final int orderId;

  const SalesOrderDetailsView({
    super.key,
    required this.orderId,
  });

  @override
  State<SalesOrderDetailsView> createState() => _SalesOrderDetailsViewState();
}

class _SalesOrderDetailsViewState extends State<SalesOrderDetailsView> {
  late final SalesOrderDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SalesOrderDetailsCubit>();
    _cubit.fetchOrderDetails(widget.orderId);
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
          title: const Text('تفاصيل الأوردر', style: AppStyle.headingMedium),
        ),
        body: BlocBuilder<SalesOrderDetailsCubit, SalesOrderDetailsState>(
          builder: (context, state) {
            if (state is SalesOrderDetailsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (state is SalesOrderDetailsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.coral),
                    const SizedBox(height: 12),
                    Text(state.errMessage, style: AppStyle.bodyMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.fetchOrderDetails(widget.orderId),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('إعادة المحاولة', style: AppStyle.buttonSmall),
                    ),
                  ],
                ),
              );
            }
            if (state is SalesOrderDetailsSuccess) {
              final order = state.order;
              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      SalesOrderDetailsHeader(order: order),
                      const SizedBox(height: 14),
                      SalesOrderDetailsCustomerCard(order: order),
                      const SizedBox(height: 14),
                      SalesOrderDetailsItemsCard(items: order.items, totalAmount: order.totalAmount),
                      const SizedBox(height: 24),
                    ],
                  ),
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

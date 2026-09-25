import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/models/customer_profile_model.dart';

class CustomerProfileOrdersCard extends StatelessWidget {
  final List<CustomerOrderModel> orders;

  const CustomerProfileOrdersCard({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'سجل الأوردرات السابقة (${orders.length})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppStyle.headingSmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (orders.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'لا يوجد سجل أوردرات سابقة لهذا العميل',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.hint,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 16,
                  color: AppColors.borderSubtle,
                );
              },
              itemBuilder: (context, index) {
                final order = orders[index];

                return InkWell(
                  onTap: () {
                    context.push(
                      AppRouter.kSalesOrderDetailsView,
                      extra: order.orderId,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // السعر
                        // Flexible(
                        //   flex: 2,
                        //   child: Text(
                        //     '${order.totalAmount} ج.م',
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //     textAlign: TextAlign.left,
                        //     style: AppStyle.labelMedium.copyWith(
                        //       color: AppColors.primary,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(width: 8),

                        // بيانات الأوردر
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'أوردر ${order.orderNumber.isNotEmpty ? order.orderNumber : "#${order.orderId}"} • ${order.orderType}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: AppStyle.labelMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'الحالة: ${order.orderStatus} • ${order.createdAt.toReadableDateTime()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: AppStyle.hint.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // سهم الانتقال
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

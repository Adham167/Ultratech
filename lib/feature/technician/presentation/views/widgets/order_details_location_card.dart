import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../data/models/order_model.dart';
import '../../manager/location_cubit/location_cubit.dart';
import '../../manager/location_cubit/location_state.dart';

class OrderDetailsLocationCard extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsLocationCard({
    super.key,
    required this.order,
  });

  void _showSettingsDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: AppColors.bgCard,
            title: Row(
              children: [
                const Icon(Icons.location_disabled_outlined, color: AppColors.coral, size: 24),
                const SizedBox(width: 8),
                const Text('صلاحية الموقع مطلوبة', style: AppStyle.headingSmall),
              ],
            ),
            content: Text(message, style: AppStyle.bodyMedium),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('إلغاء', style: AppStyle.labelMedium.copyWith(color: AppColors.textMuted)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<LocationCubit>().openAppSettings();
                },
                child: const Text('فتح الإعدادات', style: AppStyle.buttonSmall),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateLocationConfirmationDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: AppColors.bgCard,
            title: Row(
              children: [
                const Icon(Icons.my_location, color: AppColors.success, size: 24),
                const SizedBox(width: 8),
                const Text('تأكيد تحديث الموقع', style: AppStyle.headingSmall),
              ],
            ),
            content: const Text(
              'هل أنت تأكد من أنك في موقع العميل الحالي وتريد تحديث الإحداثيات؟',
              style: AppStyle.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('إلغاء', style: AppStyle.labelMedium.copyWith(color: AppColors.textMuted)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<LocationCubit>().updateOrderLocation(orderId);
                },
                child: const Text('تأكيد', style: AppStyle.buttonSmall),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is LocationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage, style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: AppColors.coral,
            ),
          );
        } else if (state is LocationPermissionDeniedForever) {
          _showSettingsDialog(context, state.errMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is LocationLoading;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text('موقع العميل والملاحة', style: AppStyle.headingSmall),
                ],
              ),
              const Divider(height: 20, color: AppColors.bgPage),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        context.read<LocationCubit>().openGoogleMaps(
                          order.customerGoogleMapsUrl,
                          order.customerLatitude,
                          order.customerLongitude,
                        );
                      },
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: Text('التوجيه عبر الخرائط', style: AppStyle.buttonSmall.copyWith(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: isLoading ? null : () => _showUpdateLocationConfirmationDialog(context, order.id),
                      icon: isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.my_location, size: 18, color: Colors.white),
                      label: Text(isLoading ? 'جاري التحديث...' : 'تحديث موقع العميل', style: AppStyle.buttonSmall.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

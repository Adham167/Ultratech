import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/models/customer_profile_model.dart';

class CustomerProfileDevicesCard extends StatelessWidget {
  final List<CustomerDeviceModel> devices;

  const CustomerProfileDevicesCard({
    super.key,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('أجهزة العميل المسجلة (${devices.length})', style: AppStyle.headingSmall),
              const SizedBox(width: 8),
              const Icon(Icons.devices, size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          if (devices.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('لا توجد أجهزة مسجلة لهذا العميل حالياً', style: AppStyle.hint),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: devices.length,
              separatorBuilder: (context, index) => const Divider(height: 16, color: AppColors.borderSubtle),
              itemBuilder: (context, index) {
                final device = devices[index];
                return Row(
                  children: [
                    if (device.maintenanceStatus != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.bgSuccess,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          device.maintenanceStatus!,
                          style: AppStyle.labelSmall.copyWith(color: AppColors.success),
                        ),
                      ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(device.productName, style: AppStyle.labelMedium),
                        if (device.nextDueDate != null)
                          Text('موعد الصيانة: ${device.nextDueDate!.toReadableDateTime()}', style: AppStyle.hint.copyWith(fontSize: 11)),
                      ],
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

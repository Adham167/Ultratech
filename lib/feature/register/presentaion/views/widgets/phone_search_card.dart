import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class PhoneSearchCard extends StatelessWidget {
  const PhoneSearchCard({super.key});

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
          const Text('البحث برقم الهاتف', style: AppStyle.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search, size: 18, color: Colors.white),
                label: const Text('بحث', style: AppStyle.buttonSmall),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '01XX XXX XXXX',
                      hintStyle: AppStyle.hint,
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      fillColor: AppColors.bgCard,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

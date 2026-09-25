import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class CreateOrderNotesField extends StatelessWidget {
  final TextEditingController controller;

  const CreateOrderNotesField({
    super.key,
    required this.controller,
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
          const Text('ملاحظات الأوردر (اختياري)', style: AppStyle.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 3,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'أدخل أي ملاحظات إضافية للفني أو تعليمات الصيانة...',
              hintStyle: AppStyle.hint,
              filled: true,
              fillColor: AppColors.bgPage,
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

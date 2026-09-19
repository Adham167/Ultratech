import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';

class CustomerDetailsCard extends StatelessWidget {
  const CustomerDetailsCard({super.key});

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
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('بيانات العميل', style: AppStyle.headingSmall),
              SizedBox(width: 6),
              Icon(
                Icons.person_add_alt_1_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('الاسم بالكامل', style: AppStyle.labelSmall),
          const SizedBox(height: 6),
          const CustomInputField(hintText: 'مثال: أميرة حسن'),
          const SizedBox(height: 12),
          const Text('العنوان بالتفصيل', style: AppStyle.labelSmall),
          const SizedBox(height: 6),
          const CustomInputField(
            hintText: 'العمارة، الشارع، رقم الشقة',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('المنطقة', style: AppStyle.labelSmall),
                    SizedBox(height: 6),
                    AreaDropdownField(),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('رقم الهاتف', style: AppStyle.labelSmall),
                    SizedBox(height: 6),
                    CustomInputField(
                      hintText: '01XX...',
                      isLtr: true,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('حفظ العميل', style: AppStyle.button),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool isLtr;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.isLtr = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: TextField(
        keyboardType: keyboardType,
        textAlign: isLtr ? TextAlign.left : TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyle.hint,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  size: 18,
                  color: AppColors.textMuted,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class AreaDropdownField extends StatelessWidget {
  const AreaDropdownField({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      hint: const Text('اختر المنطقة', style: AppStyle.hint),
      items: const [
        DropdownMenuItem(
          value: '1',
          child: Text('القاهرة الجديدة', style: AppStyle.labelSmall),
        ),
        DropdownMenuItem(
          value: '2',
          child: Text('المعادي', style: AppStyle.labelSmall),
        ),
        DropdownMenuItem(
          value: '3',
          child: Text('6 أكتوبر', style: AppStyle.labelSmall),
        ),
      ],
      onChanged: (value) {},
    );
  }
}

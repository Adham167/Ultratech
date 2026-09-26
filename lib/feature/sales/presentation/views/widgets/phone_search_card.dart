import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../manager/customer_registration_cubit.dart';
import '../../manager/customer_registration_state.dart';

class PhoneSearchCard extends StatefulWidget {
  const PhoneSearchCard({super.key});

  @override
  State<PhoneSearchCard> createState() => _PhoneSearchCardState();
}

class _PhoneSearchCardState extends State<PhoneSearchCard> {
  final TextEditingController _phoneController = TextEditingController();

  Timer? _debounce;
  Timer? _messageTimer;

  @override
  void dispose() {
    _phoneController.dispose();
    _debounce?.cancel();
    _messageTimer?.cancel();
    super.dispose();
  }

  String _sanitizePhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  void _showEmptyPhoneMessage() {
    _messageTimer?.cancel();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          backgroundColor: AppColors.bgCard,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderSubtle),
          ),
          content: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.bgError,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: AppColors.coral,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'من فضلك اكتب رقم الهاتف أولاً',
                  style: AppStyle.bodySmall,
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _onSearch() {
    final phone = _sanitizePhone(_phoneController.text.trim());

    if (phone.isEmpty) {
      _showEmptyPhoneMessage();

      // يرجع التركيز للفيلد عشان المستخدم يقدر يكتب مباشرة.
      FocusScope.of(context).requestFocus(FocusNode());

      return;
    }

    context.read<CustomerRegistrationCubit>().checkPhone(phone);
  }

  void _onPhoneChanged(String value) {
    final cleaned = _sanitizePhone(value);

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    // لو الرقم فاضي، مفيش داعي لأي Search.
    if (cleaned.isEmpty) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      if (cleaned.length == 11) {
        context.read<CustomerRegistrationCubit>().checkPhone(cleaned);
      }
    });
  }

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
              BlocBuilder<CustomerRegistrationCubit, CustomerRegistrationState>(
                builder: (context, state) {
                  final isLoading = state is PhoneSearchLoading;

                  return ElevatedButton(
                    onPressed: isLoading ? null : _onSearch,
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
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.search, size: 18, color: Colors.white),
                              SizedBox(width: 4),
                              Text('بحث', style: AppStyle.buttonSmall),
                            ],
                          ),
                  );
                },
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextField(
                    controller: _phoneController,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.phone,

                    // البحث من زر Search في الكيبورد.
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _onSearch();
                    },

                    onChanged: _onPhoneChanged,

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

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'قم بكتابة رقم الهاتف للتحقق من وجود العميل',
              style: AppStyle.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

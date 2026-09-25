import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/app_validator.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_header.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إرسال تعليمات إعادة تعيين كلمة السر بنجاح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // iconTheme: const IconDataThemeData(color: AppColors.textHeading),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const AuthHeader(
                title: 'نسيت كلمة السر',
                subtitle: 'أدخل رقم هاتفك المسجل لإرسال رابط إعادة التعيين.',
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthFormCard(
                      children: [
                        const Text('رقم الهاتف', style: AppStyle.labelMedium),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: '01XXXXXXXXX',
                          prefixIcon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          isLtr: true,
                          validator: AppValidator.validatePhone,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'إرسال رابط التعيين',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

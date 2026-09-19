import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import 'auth_header.dart';
import 'login_form.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            const AuthHeader(
              title: 'تسجيل الدخول',
              subtitle: 'مرحباً بعودتك! أدخل بياناتك للوصول إلى حسابك',
            ),
            const SizedBox(height: 35),
            const LoginForm(),
            const SizedBox(height: 25),
            Center(child: _buildSignUpRedirect(context)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpRedirect(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppStyle.bodyMedium,
        children: [
          const TextSpan(text: 'ليس لديك حساب؟ '),
          TextSpan(
            text: 'إنشاء حساب جديد',
            style: AppStyle.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                GoRouter.of(context).pushReplacement(AppRouter.kSignUpView);
              },
          ),
        ],
      ),
    );
  }
}

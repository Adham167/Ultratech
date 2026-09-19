import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_router.dart';
import '../../../../../core/utils/app_style.dart';
import 'auth_header.dart';
import 'sign_up_form.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const AuthHeader(
              title: 'إنشاء حساب جديد',
              subtitle: 'قم بإدخال بياناتك للانضمام إلى فريق الترا تك',
            ),
            const SizedBox(height: 30),
            const SignUpForm(),
            const SizedBox(height: 20),
            Center(child: _buildLoginRedirect(context)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppStyle.bodyMedium,
        children: [
          const TextSpan(text: 'لديك حساب بالفعل؟ '),
          TextSpan(
            text: 'تسجيل الدخول',
            style: AppStyle.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
              },
          ),
        ],
      ),
    );
  }
}

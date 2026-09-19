import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../manager/auth_cubit.dart';
import '../../manager/auth_state.dart';
import 'auth_form_card.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  bool _isPasswordObscure = true;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthFormCard(
            children: [
              const Text('رقم الهاتف', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: phoneController,
                hintText: '01XXXXXXXXX',
                prefixIcon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                isLtr: true,
                validator: AppValidator.validatePhone,
              ),
              const SizedBox(height: 20),
              const Text('كلمة السر', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: passwordController,
                hintText: '********',
                prefixIcon: Icons.lock_outline,
                obscureText: _isPasswordObscure,
                validator: AppValidator.validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: 'تسجيل الدخول',
                isLoading: state is AuthLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().login(
                          phoneNumber: phoneController.text.trim(),
                          password: passwordController.text,
                        );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

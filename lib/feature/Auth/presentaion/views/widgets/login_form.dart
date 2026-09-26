import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../manager/login_cubit/login_cubit.dart';
import '../../manager/login_cubit/login_state.dart';
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
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
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
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            phoneNumber: phoneController.text.trim(),
            password: passwordController.text,
          );
    }
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
                focusNode: phoneFocusNode,
                hintText: '01XXXXXXXXX',
                prefixIcon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                isLtr: true,
                validator: AppValidator.validatePhone,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  passwordFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 20),
              const Text('كلمة السر', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                hintText: '********',
                prefixIcon: Icons.lock_outline,
                obscureText: _isPasswordObscure,
                validator: AppValidator.validatePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(context),
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    context.push('/forgot-password');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'نسيت كلمة السر؟',
                    style: AppStyle.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return CustomButton(
                text: 'تسجيل الدخول',
                isLoading: state is LoginLoading,
                onPressed: () => _submit(context),
              );
            },
          ),
        ],
      ),
    );
  }
}

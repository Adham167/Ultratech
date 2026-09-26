import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/utils/user_role.dart';
import '../../manager/register_cubit/register_cubit.dart';
import '../../manager/register_cubit/register_state.dart';
import 'auth_form_card.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  UserRole selectedRole = UserRole.sales;

  final List<UserRole> roles = [
    UserRole.sales,
    UserRole.technician,
  ];

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            password: passwordController.text,
            role: selectedRole,
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
              const Text('الاسم بالكامل', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: fullNameController,
                focusNode: fullNameFocusNode,
                hintText: 'أدخل اسمك الثلاثي',
                prefixIcon: Icons.person_outline,
                validator: AppValidator.validateName,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
              ),
              const SizedBox(height: 20),
              const Text('البريد الإلكتروني', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: emailController,
                focusNode: emailFocusNode,
                hintText: 'example@mail.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isLtr: true,
                validator: AppValidator.validateEmail,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
              ),
              const SizedBox(height: 20),
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
                onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
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
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
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
              const SizedBox(height: 20),
              const Text('تأكيد كلمة السر', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              CustomTextField(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                hintText: '********',
                prefixIcon: Icons.lock_outline,
                obscureText: _isConfirmPasswordObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'برجاء تأكيد كلمة السر';
                  }
                  if (value != passwordController.text) {
                    return 'كلمة السر غير متطابقة';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(context),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('نوع الوظيفة / Role', style: AppStyle.labelMedium),
              const SizedBox(height: 8),
              _buildRoleDropdown(),
            ],
          ),
          const SizedBox(height: 30),
          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              return CustomButton(
                text: 'تسجيل حساب جديد',
                isLoading: state is RegisterLoading,
                onPressed: () => _submit(context),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<UserRole>(
      initialValue: selectedRole,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.badge_outlined, size: 20, color: AppColors.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: AppColors.bgPage.withValues(alpha: 0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
      hint: const Text('اختر الدور', style: AppStyle.hint),
      items: roles.map((role) {
        return DropdownMenuItem<UserRole>(
          value: role,
          child: Text(role.nameAr, style: AppStyle.labelSmall),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedRole = value ?? UserRole.sales),
      validator: (value) => value == null ? 'برجاء اختيار الدور' : null,
    );
  }
}

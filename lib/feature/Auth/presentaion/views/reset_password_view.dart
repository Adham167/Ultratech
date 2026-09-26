import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/forgot_password_cubit/forgot_password_cubit.dart';
import '../manager/forgot_password_cubit/forgot_password_state.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_header.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class ResetPasswordView extends StatefulWidget {
  final String identifier;
  final String otp;

  const ResetPasswordView({
    super.key,
    required this.identifier,
    required this.otp,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    print('RESET identifier = "${widget.identifier}"');
    print('RESET otp = "${widget.otp}"');
    print('RESET password = "${_newPasswordController.text}"');
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ForgotPasswordCubit>().resetPassword(
          emailOrPhone: widget.identifier,
          code: widget.otp,
          newPassword: _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 28),
                      SizedBox(width: 8),
                      Text('تم تغيير كلمة السر',
                          style: AppStyle.headingSmall),
                    ],
                  ),
                  content: Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'تم تغيير كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.',
                    style: AppStyle.bodyMedium,
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        GoRouter.of(context).go(AppRouter.kLoginView,);
                      },
                      child: const Text('تسجيل الدخول',
                          style: AppStyle.buttonSmall),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errMessage,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: AppColors.coral,
                ),
              );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ResetPasswordLoading;

          return Scaffold(
            backgroundColor: AppColors.bgPage,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: AppColors.textHeading,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    const AuthHeader(
                      title: 'إعادة تعيين كلمة السر',
                      subtitle:
                          'أدخل كلمة السر الجديدة وتأكيدها لإكمال العملية.',
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthFormCard(
                            children: [
                              const Text(
                                'كلمة السر الجديدة',
                                style: AppStyle.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _newPasswordController,
                                focusNode: _newPasswordFocusNode,
                                hintText: '********',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _isNewPasswordObscure,
                                validator: AppValidator.validatePassword,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  _confirmPasswordFocusNode.requestFocus();
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isNewPasswordObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPasswordObscure =
                                          !_isNewPasswordObscure;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'تأكيد كلمة السر الجديدة',
                                style: AppStyle.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,
                                hintText: '********',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _isConfirmPasswordObscure,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'برجاء تأكيد كلمة السر';
                                  }
                                  if (value !=
                                      _newPasswordController.text) {
                                    return 'كلمتا المرور غير متطابقتين';
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
                                      _isConfirmPasswordObscure =
                                          !_isConfirmPasswordObscure;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: 'تغيير كلمة المرور',
                            isLoading: isLoading,
                            onPressed:
                                isLoading ? null : () => _submit(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

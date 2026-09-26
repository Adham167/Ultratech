import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/forgot_password_cubit/forgot_password_cubit.dart';
import '../manager/forgot_password_cubit/forgot_password_state.dart';
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

  final TextEditingController _identifierController =
      TextEditingController();
  final FocusNode _identifierFocusNode = FocusNode();

  @override
  void dispose() {
    _identifierController.dispose();
    _identifierFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final identifier = _identifierController.text.trim();

    context.read<ForgotPasswordCubit>().forgotPassword(
          identifier: identifier,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'تم إرسال كود التحقق بنجاح',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                    ),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );

            context.push(
              AppRouter.kOtpVerificationView,
              extra: _identifierController.text.trim(),
            );
          }

          if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errMessage,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                    ),
                  ),
                  backgroundColor: AppColors.coral,
                ),
              );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ForgotPasswordLoading;

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
                      title: 'نسيت كلمة السر',
                      subtitle:
                          'أدخل بريدك الإلكتروني المسجل لإرسال كود التحقق.',
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthFormCard(
                            children: [
                              const Text(
                                'البريد الإلكتروني ',
                                style: AppStyle.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _identifierController,
                                focusNode: _identifierFocusNode,
                                hintText: 'example@mail.com',
                                prefixIcon:
                                    Icons.alternate_email_rounded,
                                keyboardType:
                                    TextInputType.emailAddress,
                                isLtr: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'برجاء إدخال البريد الإلكتروني';
                                  }
                                  return null;
                                },
                                textInputAction:
                                    TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: 'إرسال كود التحقق',
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

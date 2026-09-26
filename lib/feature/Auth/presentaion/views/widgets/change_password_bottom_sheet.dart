import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/utils/service_locator.dart';
import '../../manager/auth_cubit.dart';
import '../../manager/auth_state.dart';
import 'auth_form_card.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState
    extends State<ChangePasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _currentFocusNode = FocusNode();
  final FocusNode _newFocusNode = FocusNode();
  final FocusNode _confirmFocusNode = FocusNode();

  bool _isCurrentObscure = true;
  bool _isNewObscure = true;
  bool _isConfirmObscure = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentFocusNode.dispose();
    _newFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isNotEmpty
                      ? state.message
                      : 'تم تغيير كلمة السر بنجاح',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: AppColors.success,
              ),
            );
          }

          if (state is ChangePasswordError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.error,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: AppColors.coral,
                ),
              );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ChangePasswordLoading;

          return Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.borderSubtle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'تغيير كلمة السر',
                        style: AppStyle.headingMedium,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'أدخل كلمة السر الحالية وكلمة السر الجديدة.',
                        style: AppStyle.bodySmall,
                      ),
                      const SizedBox(height: 20),
                      AuthFormCard(
                        children: [
                          const Text(
                            'كلمة السر الحالية',
                            style: AppStyle.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _currentPasswordController,
                            focusNode: _currentFocusNode,
                            hintText: '********',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _isCurrentObscure,
                            validator: AppValidator.validatePassword,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _newFocusNode.requestFocus();
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isCurrentObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isCurrentObscure = !_isCurrentObscure;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'كلمة السر الجديدة',
                            style: AppStyle.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: _newPasswordController,
                            focusNode: _newFocusNode,
                            hintText: '********',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _isNewObscure,
                            validator: AppValidator.validatePassword,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _confirmFocusNode.requestFocus();
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isNewObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isNewObscure = !_isNewObscure;
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
                            focusNode: _confirmFocusNode,
                            hintText: '********',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _isConfirmObscure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'برجاء تأكيد كلمة السر';
                              }
                              if (value != _newPasswordController.text) {
                                return 'كلمة السر غير متطابقة';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(context),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmObscure = !_isConfirmObscure;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'حفظ التغييرات',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : () => _submit(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

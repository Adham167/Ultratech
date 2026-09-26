import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/forgot_password_cubit/forgot_password_cubit.dart';
import '../manager/forgot_password_cubit/forgot_password_state.dart';
import 'widgets/auth_header.dart';
import 'widgets/custom_button.dart';

class OtpVerificationView extends StatefulWidget {
  final String identifier;

  const OtpVerificationView({
    super.key,
    required this.identifier,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late Timer _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto focus first OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        _timer.cancel();
        if (mounted) {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _onResend(BuildContext context) {
    if (!_canResend) return;
    context.read<ForgotPasswordCubit>().resendOtp(
          identifier: widget.identifier,
        );
  }

  void _submitOtp() {
    final code = _otpCode;
    if (code.length < 6) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'برجاء إدخال كود التحقق كاملًا المكون من 6 أرقام',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: AppColors.coral,
          ),
        );
      return;
    }

    setState(() {
      _hasError = false;
    });

    // Navigate to Reset Password view passing identifier & otp code
    print('OTP identifier = "${widget.identifier}"');
    print('OTP code = "$code"');
    context.push(
      AppRouter.kResetPasswordView,
      extra: {
        'identifier': widget.identifier,
        'otp': code,
      },
    );
  }

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ResendOtpSuccess) {
            _startTimer();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'تم إرسال كود جديد بنجاح',
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
          }

          if (state is ResendOtpFailure) {
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
          final bool isResending = state is ResendOtpLoading;

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
                    AuthHeader(
                      title: 'كود التحقق (OTP)',
                      subtitle:
                          'تم إرسال كود مكون من 6 أرقام إلى (${widget.identifier}). الكود صالح لمدة 15 دقيقة.',
                    ),
                    const SizedBox(height: 32),

                    // 6 OTP Square Input Boxes
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 46,
                            height: 54,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: KeyboardListener(
                              focusNode: FocusNode(),
                              onKeyEvent: (event) {
                                if (event is KeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.backspace &&
                                    _controllers[index].text.isEmpty &&
                                    index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                              child: TextFormField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: AppStyle.headingMedium.copyWith(
                                  color: AppColors.textHeading,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor:
                                      AppColors.bgPage.withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _hasError
                                          ? AppColors.coral
                                          : AppColors.borderSubtle,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _hasError
                                          ? AppColors.coral
                                          : AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (_hasError) {
                                    setState(() {
                                      _hasError = false;
                                    });
                                  }

                                  // Handle paste of 6 digits in first box
                                  if (index == 0 && value.length == 6) {
                                    for (int i = 0; i < 6; i++) {
                                      _controllers[i].text = value[i];
                                    }
                                    _focusNodes[5].unfocus();
                                    _submitOtp();
                                    return;
                                  }

                                  if (value.isNotEmpty && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  }

                                  if (_otpCode.length == 6) {
                                    _submitOtp();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Countdown & Resend Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_canResend) ...[
                          Text(
                            'يمكنك إعادة إرسال الكود بعد ',
                            style: AppStyle.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            _formatTimer(_remainingSeconds),
                            style: AppStyle.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else ...[
                          TextButton(
                            onPressed:
                                isResending ? null : () => _onResend(context),
                            child: isResending
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Text(
                                    'إعادة إرسال الكود',
                                    style: AppStyle.labelMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 32),

                    CustomButton(
                      text: 'متابعة',
                      onPressed: _submitOtp,
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

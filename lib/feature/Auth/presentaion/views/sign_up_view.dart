import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(AppRouter.kPendingApprovalView);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: AppColors.coral,
                ),
              );
            }
          },
          child: const SignUpViewBody(),
        ),
      ),
    );
  }
}

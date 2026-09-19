import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/auth_helper.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              AuthHelper.handleAuthNavigation(
                context,
                roleId: state.user.role,
                isApproved: state.user.isApproved,
              );
            } else if (state is PendingApproval) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('عذراً، حسابك لا يزال قيد المراجعة من قبل الإدارة.'),
                  backgroundColor: Colors.orange,
                ),
              );
              context.push(AppRouter.kPendingApprovalView);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: AppColors.coral,
                ),
              );
            }
          },
          child: const LoginViewBody(),
        ),
      ),
    );
  }
}

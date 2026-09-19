import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/utils/auth_helper.dart';
import '../../../../core/utils/service_locator.dart';
import 'widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final storage = getIt<FlutterSecureStorage>();
    final token = await storage.read(key: 'token');
    final isApprovedStr = await storage.read(key: 'isApproved');
    final roleStr = await storage.read(key: 'role');

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      context.go(AppRouter.kLoginView);
    } else {
      final bool isApproved = isApprovedStr == 'true';
      final int roleId = int.tryParse(roleStr ?? '') ?? 3;
      AuthHelper.handleAuthNavigation(context, roleId: roleId, isApproved: isApproved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: SplashViewBody(),
    );
  }
}

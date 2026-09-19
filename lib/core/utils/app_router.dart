import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/login_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/sign_up_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/pending_approval_view.dart';
import 'package:ultra_tech/feature/splash/presentain/views/splash_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_wrapper_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_orders_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_invoice_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_archive_view.dart';

import '../../feature/main_wrapper_view/presentaion/views/main_wrapper_view.dart';
import '../../feature/maintenance_duties_view/views/maintenance_duties_view.dart';
import '../../feature/register/presentaion/views/register_view.dart';

abstract class AppRouter {
  static const kLoginView = '/login';
  static const kSignUpView = '/sign-up';
  static const kPendingApprovalView = '/pending-approval';
  static const kRegisterView = '/register';
  static const kMaintenanceDutiesView = '/maintenance';

  // مسارات الفني
  static const kTechnicianOrdersView = '/technician-orders';
  static const kTechnicianInvoiceView = '/technician-invoice';
  static const kTechnicianArchiveView = '/technician-archive';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: <RouteBase>[
      // 1. Splash Screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),

      // 2. Auth Screens
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: kSignUpView,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: kPendingApprovalView,
        builder: (context, state) => const PendingApprovalView(),
      ),

      // 3. Sales Shell (تطبيق المبيعات)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kRegisterView,
                builder: (context, state) => const RegisterView(), // This is the search/register customer screen
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kMaintenanceDutiesView,
                builder: (context, state) => const MaintenanceDutiesView(),
              ),
            ],
          ),
        ],
      ),

      // 4. Technician Shell (تطبيق الفني)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TechnicianWrapperView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kTechnicianOrdersView,
                builder: (context, state) => const TechnicianOrdersView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kTechnicianInvoiceView,
                builder: (context, state) => const TechnicianInvoiceView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kTechnicianArchiveView,
                builder: (context, state) => const TechnicianArchiveView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ultra_tech/core/utils/service_locator.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/forgot_password_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/otp_verification_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/login_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/sign_up_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/reset_password_view.dart';
import 'package:ultra_tech/feature/Auth/presentaion/views/pending_approval_view.dart';
import 'package:ultra_tech/feature/sales/presentation/views/create_order_view.dart';
import 'package:ultra_tech/feature/sales/presentation/views/customer_profile_view.dart';
import 'package:ultra_tech/feature/sales/presentation/views/sales_order_details_view.dart';
import 'package:ultra_tech/feature/splash/presentain/views/splash_view.dart';
import 'package:ultra_tech/feature/technician/data/models/order_model.dart';
import 'package:ultra_tech/feature/technician/presentation/manager/orders_cubit/technician_orders_cubit.dart';
import 'package:ultra_tech/feature/technician/presentation/views/complete_order_screen.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_order_details_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_wrapper_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_orders_view.dart';
import 'package:ultra_tech/feature/technician/presentation/views/technician_archive_view.dart';
import 'package:ultra_tech/feature/main_wrapper_view/presentaion/views/main_wrapper_view.dart';
import 'package:ultra_tech/feature/sales/presentation/views/sales_customer_onboarding_view.dart';
import 'package:ultra_tech/feature/sales/presentation/views/maintenance_tab_view.dart';

import '../../feature/sales/presentation/views/sales_profile_view.dart';
import '../../feature/technician/presentation/views/technician_earnings_view.dart';
import '../../feature/technician/presentation/views/technician_invoice_details_view.dart';

abstract class AppRouter {
  static const kLoginView = '/login';
  static const kSignUpView = '/sign-up';
  static const kForgotPasswordView = '/forgot-password';
  static const kOtpVerificationView = '/otp-verification';
  static const kResetPasswordView = '/reset-password';
  static const kPendingApprovalView = '/pending-approval';
  static const kSalesDashboard = '/register';
  static const kRegisterView = '/register';
  static const kMaintenanceDutiesView = '/maintenance';
  static const kSalesProfileView = '/sales-profile';
  static const kCustomerProfileView = '/customer-profile';
  static const kCreateOrderView = '/create-order';
  static const kSalesOrderDetailsView = '/sales-order-details';

  // مسارات الفني
  static const kTechnicianOrdersView = '/technician-orders';
  static const kTechnicianInvoiceView = '/technician-invoice';
  static const kTechnicianArchiveView = '/technician-archive';
  static const kTechnicianEarningsView = '/technician-earnings';
  static const kTechnicianOrderDetailsView = '/technician-order-details';
  static const kCompleteOrderScreen = '/complete-order';
  static const kTechnicianInvoiceDetailsView =
      '/technician-invoice-details/:id';
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
        path: kForgotPasswordView,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: kOtpVerificationView,
        builder: (context, state) {
          final identifier = state.extra as String? ?? '';
          return OtpVerificationView(identifier: identifier);
        },
      ),
      GoRoute(
        path: kResetPasswordView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final identifier = extra['identifier'] as String? ?? '';
          final otp = extra['otp'] as String? ?? '';
          return ResetPasswordView(
            identifier: identifier,
            otp: otp,
          );
        },
      ),
      GoRoute(
        path: kPendingApprovalView,
        builder: (context, state) => const PendingApprovalView(),
      ),

      // 3. Sales Shell (تطبيق المبيعات) - Bottom Navigation Layout
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperView(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kRegisterView,
                builder: (context, state) => const SalesCustomerOnboardingView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kMaintenanceDutiesView,
                builder: (context, state) => const MaintenanceTabView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kSalesProfileView,
                builder: (context, state) => const SalesProfileView(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: kCustomerProfileView,
        builder: (context, state) {
          final customerId = state.extra as int;
          return CustomerProfileView(customerId: customerId);
        },
      ),

      GoRoute(
        path: kCreateOrderView,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return CreateOrderView(
            customerId: data['customerId'] as int,
            customerName: data['customerName'] as String,
          );
        },
      ),

      GoRoute(
        path: kSalesOrderDetailsView,
        builder: (context, state) {
          final orderId = state.extra as int;
          return SalesOrderDetailsView(orderId: orderId);
        },
      ),

      // 4. Technician Shell (تطبيق الفني)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TechnicianWrapperView(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.kTechnicianOrdersView,
                builder: (context, state) {
                  return const TechnicianOrdersView();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.kTechnicianEarningsView,
                builder: (context, state) {
                  return const TechnicianEarningsView();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.kTechnicianArchiveView,
                builder: (context, state) {
                  return const TechnicianArchiveView();
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRouter.kTechnicianOrderDetailsView,
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return BlocProvider.value(
            value: getIt<TechnicianOrdersCubit>(),
            child: TechnicianOrderDetailsView(
              order: order,
            ),
          );
        },
      ),

      GoRoute(
        path: AppRouter.kCompleteOrderScreen,
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return CompleteOrderScreen(order: order);
        },
      ),

      GoRoute(
        path: AppRouter.kTechnicianInvoiceDetailsView,
        builder: (context, state) {
          final invoiceId = int.parse(
            state.pathParameters['id']!,
          );

          return TechnicianInvoiceDetailsView(
            invoiceId: invoiceId,
          );
        },
      ),
    ],
  );
}

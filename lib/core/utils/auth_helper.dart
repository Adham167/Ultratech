import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

class AuthHelper {
  static void handleAuthNavigation(BuildContext context, {required int roleId, required bool isApproved}) {
    if (!isApproved) {
      context.go(AppRouter.kPendingApprovalView);
      return;
    }

    switch (roleId) {
      case 1: // CEO
      case 2: // Accountant
      case 3: // Sales
        context.go(AppRouter.kMaintenanceDutiesView);
        break;
      case 4: // Technical
        context.go(AppRouter.kTechnicianOrdersView);
        break;
      default:
        context.go(AppRouter.kMaintenanceDutiesView);
    }
  }
}

import 'package:go_router/go_router.dart';

import '../../feature/technician/presentation/views/technician_archive_view.dart';
import '../../feature/technician/presentation/views/technician_invoice_view.dart';
import '../../feature/technician/presentation/views/technician_orders_view.dart';
import '../../feature/technician/presentation/views/technician_wrapper_view.dart';

abstract class TechnicianRouter {
  static const kOrdersView = '/tech-orders';
  static const kInvoiceView = '/tech-invoice';
  static const kArchiveView = '/tech-archive';

  static final branch = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return TechnicianWrapperView(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: kOrdersView,
            builder: (context, state) => const TechnicianOrdersView(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: kInvoiceView,
            builder: (context, state) => const TechnicianInvoiceView(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: kArchiveView,
            builder: (context, state) => const TechnicianArchiveView(),
          ),
        ],
      ),
    ],
  );
}
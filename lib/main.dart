import 'package:flutter/material.dart';
import 'core/utils/app_router.dart';
import 'core/utils/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const UltraTech());
}

class UltraTech extends StatelessWidget {
  const UltraTech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}

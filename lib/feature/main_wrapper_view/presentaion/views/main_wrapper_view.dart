import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_wrapper_bottom_nav.dart';

class MainWrapperView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: MainWrapperBottomNav(navigationShell: navigationShell),
    );
  }
}

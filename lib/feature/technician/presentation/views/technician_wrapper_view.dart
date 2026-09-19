import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/technician_bottom_nav.dart';

class TechnicianWrapperView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TechnicianWrapperView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: TechnicianBottomNav(navigationShell: navigationShell),
    );
  }
}

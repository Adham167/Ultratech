import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import 'nav_item.dart';

class MainWrapperBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapperBottomNav({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPage,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 8),
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: NavItem(
                icon: Icons.person_add_alt_outlined,
                activeIcon: Icons.person_add_alt_1_rounded,
                label: 'تسجيل العملاء',
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _onTap(0),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment_rounded,
                label: 'الصيانة الدورية',
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _onTap(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

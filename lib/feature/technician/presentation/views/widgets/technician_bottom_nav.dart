import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import 'tech_nav_item.dart';

class TechnicianBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TechnicianBottomNav({
    super.key,
    required this.navigationShell,
  });

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
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 16,
        top: 8,
      ),
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TechNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'البروفايل والأرباح',
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _onTap(1),
              ),
            ),
            Expanded(
              child: TechNavItem(
                icon: Icons.inbox_outlined,
                activeIcon: Icons.inbox_rounded,
                label: 'الأوردرات',
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _onTap(0),
              ),
            ),

            Expanded(
              child: TechNavItem(
                icon: Icons.access_time,
                activeIcon: Icons.access_time_filled,
                label: 'الأرشيف',
                isSelected: navigationShell.currentIndex == 2,
                onTap: () => _onTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CirandaBottomNav extends StatelessWidget {
  const CirandaBottomNav({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Início', route: '/home'),
    _NavItem(
        icon: Icons.celebration_rounded,
        label: 'Festivais',
        route: '/festivais'),
    _NavItem(icon: Icons.groups_rounded, label: 'Quadrilhas', route: '/quadrilhas'),
    _NavItem(
        icon: Icons.emoji_events_rounded,
        label: 'Resultados',
        route: '/resultados'),
    _NavItem(icon: Icons.person_rounded, label: 'Perfil', route: '/perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = navigationShell.currentIndex == index;

              return Expanded(
                child: _NavButton(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    navigationShell.goBranch(
                      index,
                      initialLocation:
                          index == navigationShell.currentIndex,
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary;
    const inactiveColor = AppColors.textHint;
    final color = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 40 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: AppColors.primary,
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: isSelected
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                  : EdgeInsets.zero,
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Icon(item.icon, color: color, size: 24),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

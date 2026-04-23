import 'package:comfi/components/bottom_navigation.dart';
import 'package:comfi/components/sidebar.dart';
import 'package:comfi/consts/theme_toggle_button.dart';
import 'package:comfi/layouts/app_shell_destination.dart';
import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

class BuyerResponsiveShell extends StatelessWidget {
  const BuyerResponsiveShell({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AppShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = Responsive.isTablet(context, constraints: constraints);
        final isDesktop = Responsive.isDesktop(context, constraints: constraints);
        final background = Theme.of(context).scaffoldBackgroundColor;

        return Scaffold(
          backgroundColor: background,
          body: Row(
            children: [
              if (isTablet)
                _TabletNavigationRail(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onSelect: onDestinationSelected,
                ),
              if (isDesktop)
                Sidebar(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onSelect: onDestinationSelected,
                ),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: destinations
                      .map((destination) => RepaintBoundary(child: destination.page))
                      .toList(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: !isTablet && !isDesktop
              ? MyBottomNavigation(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onTabChange: onDestinationSelected,
                )
              : null,
        );
      },
    );
  }
}

class _TabletNavigationRail extends StatelessWidget {
  const _TabletNavigationRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<AppShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final railBackground = isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFE2E8F0);

    return Container(
      width: 104,
      decoration: BoxDecoration(
        color: railBackground,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4C1D95), Color(0xFF7C3AED), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelect,
                backgroundColor: Colors.transparent,
                useIndicator: true,
                indicatorColor: const Color(0xFF8B5CF6).withValues(alpha: 0.14),
                labelType: NavigationRailLabelType.all,
                groupAlignment: -0.9,
                destinations: destinations
                    .map(
                      (destination) => NavigationRailDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.activeIcon),
                        label: Text(destination.label),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ThemeToggleButton(
                surfaceColor: isDark ? const Color(0xFF111827) : Colors.white,
                borderColor: borderColor,
                size: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

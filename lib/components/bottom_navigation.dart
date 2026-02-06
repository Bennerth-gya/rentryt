import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavigation extends StatelessWidget {
  final void Function(int) onTabChange;
  final int selectedIndex;

  const MyBottomNavigation({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isTablet = width >= 600;
    final double iconSize = isTablet ? 28 : 24;
    final double navHeight = isTablet ? 80 : 70;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          height: navHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,

            rippleColor: Colors.grey.shade200,
            hoverColor: Colors.grey.shade100,

            haptic: true,
            tabBorderRadius: 24,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 400),

            gap: 10,
            iconSize: iconSize,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

            color: Colors.grey.shade500,
            activeColor: Colors.black,

            tabBackgroundColor: Colors.grey.shade100,

            tabs: const [
              GButton(icon: Icons.home_rounded, text: 'Home'),
              GButton(icon: Icons.grid_view_rounded, text: 'Categories'),
              GButton(icon: Icons.shopping_bag_rounded, text: 'Cart'),
              GButton(icon: Icons.person_rounded, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

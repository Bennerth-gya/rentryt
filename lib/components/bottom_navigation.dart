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

    // Responsive breakpoints
    final bool isTablet = width >= 600;
    final double iconSize = isTablet ? 26 : 22;
    final double navHeight = isTablet ? 70 : 60;

    return SafeArea(
      child: Container(
        height: navHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: GNav(
          selectedIndex: selectedIndex,
          iconSize: iconSize,
          gap: 6,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: Colors.grey[400],
          activeColor: Colors.grey.shade700,
          tabBackgroundColor: Colors.grey.shade100,
          tabBorderRadius: 14,
          onTabChange: onTabChange,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.category, text: 'Categories'),
            GButton(icon: Icons.shopping_bag, text: 'Cart'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}

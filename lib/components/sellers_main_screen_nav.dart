// lib/pages/seller/seller_main_screen.dart
// import 'package:comfi/consts/colors.dart';
import 'package:comfi/pages/sellers_dashboard_screen.dart';
import 'package:comfi/pages/seller_orders_screen.dart';
import 'package:comfi/pages/seller_post_product_screen.dart';
import 'package:comfi/pages/sellers_menu_screen.dart';
import 'package:comfi/pages/sellers_refund_screen.dart';
import 'package:comfi/pages/sellers_shoppage.dart';
import 'package:flutter/material.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SellerDashboardScreen(),       // index 0 - Home
    SellerOrdersScreen(),          // index 1 - My Orders
    SellerPostProductScreen(),     // index 2 - Post
    SellerShopPage(),              // index 3 - Shop
    SellerRefundScreen(order: {}), // index 4 - Refund
    SellerMenuScreen(),            // index 5 - Menu
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _SellerNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ── Custom Seller Navigation Bar ─────────────────────────────────────────────
class _SellerNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _SellerNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded,         activeIcon: Icons.home_rounded,         label: 'Home'),
    _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long_rounded, label: 'Orders'),
    _NavItem(icon: Icons.add,                  activeIcon: Icons.add,                  label: 'Post'),
    _NavItem(icon: Icons.storefront_outlined,  activeIcon: Icons.storefront_rounded,   label: 'Shop'),
    _NavItem(icon: Icons.refresh_rounded,      activeIcon: Icons.refresh_rounded,      label: 'Refund'),
    _NavItem(icon: Icons.menu_rounded,         activeIcon: Icons.menu_rounded,         label: 'Menu'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor      = isDark ? const Color(0xFF111827) : Colors.white;
    final borderTop    = isDark ? Colors.white.withOpacity(0.07) : const Color(0xFFE2E8F0);
    final activeColor  = const Color(0xFF6B4EFF);
    final inactiveColor= isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF94A3B8);
    final activeBg     = const Color(0xFF6B4EFF).withOpacity(0.12);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderTop, width: 1)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item     = _items[index];
              final isActive = index == selectedIndex;
              final isPost   = index == 2; // special "Post" button

              if (isPost) {
                // ── FAB-style centre Post button ──────────────────────
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF6B4EFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B4EFF).withOpacity(0.45),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                );
              }

              // ── Regular nav item ──────────────────────────────────
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? activeBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isActive ? item.activeIcon : item.icon,
                          key: ValueKey(isActive),
                          color: isActive ? activeColor : inactiveColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive ? activeColor : inactiveColor,
                          letterSpacing: 0.1,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Nav Item Data Model ───────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
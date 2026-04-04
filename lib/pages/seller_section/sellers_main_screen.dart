import 'package:comfi/pages/sellers_shoppage.dart';
//import 'package:comfi/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../products/my_products_screen.dart';
import '../seller_post_product_screen.dart';
import '../sellers_dashboard_screen.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _scaleAnims;

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      label: 'Shop',
      color: Color(0xFF8B5CF6),
    ),
    _NavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
      label: 'Products',
      color: Color(0xFF06B6D4),
    ),
    _NavItem(
      icon: Icons.add_circle_outline_rounded,
      activeIcon: Icons.add_circle_rounded,
      label: 'Post',
      color: Color(0xFF34D399),
    ),
    _NavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics_rounded,
      label: 'Dashboard',
      color: Color(0xFFF59E0B),
    ),
  ];

  final List<Widget> _pages = [
    const SellerShopPage(),
    const MyProductsScreen(),
    const SellerPostProductScreen(),
    const SellerDashboardScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _itemControllers = List.generate(
      _navItems.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: i == 0 ? 1.0 : 0.0,
      ),
    );
    _scaleAnims = _itemControllers
        .map((c) => Tween<double>(begin: 0.85, end: 1.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOutBack),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.lightImpact();
    _itemControllers[_selectedIndex].reverse();
    _itemControllers[index].forward();
    setState(() => _selectedIndex = index);
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = index == _selectedIndex;
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final color = _navItems[index].color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        tileColor: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isSelected ? _navItems[index].activeIcon : icon,
            color: isSelected
                ? color
                : isDark
                    ? Colors.white.withOpacity(0.45)
                    : const Color(0xFF94A3B8),
            size: 20,
          ),
        ),
        title: Text(title,
          style: TextStyle(
            color: isSelected ? color : primaryText,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 7, height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          Navigator.pop(context);
          _onNavTap(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final drawerBg =
        isDark ? const Color(0xFF111827) : Colors.white;
    final navBg =
        isDark ? const Color(0xFF111827) : Colors.white;
    final navBorder = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE2E8F0);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: scaffoldBg,
      extendBody: true,

      // ── DRAWER ──────────────────────────────────────
      drawer: Drawer(
        backgroundColor: drawerBg,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            // Gradient header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(Icons.storefront_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 14),
                  const Text('Seller Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Manage your store',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(Icons.storefront_rounded,   'Shop',        0),
                  _drawerItem(Icons.inventory_2_rounded,  'My Products', 1),
                  _drawerItem(Icons.add_circle_rounded,   'Post Product',2),
                  _drawerItem(Icons.analytics_rounded,    'Dashboard',   3),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.18),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Color(0xFF8B5CF6), size: 16),
                    const SizedBox(width: 10),
                    Text('Comfi Seller v1.0',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFFA78BFA)
                            : const Color(0xFF6D28D9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── BODY ────────────────────────────────────────
      body: _pages[_selectedIndex],

      // ── FLOATING BOTTOM NAV ──────────────────────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: navBg,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: navBorder),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.5)
                    : const Color(0xFF8B5CF6).withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.25)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final item     = _navItems[i];
                final selected = i == _selectedIndex;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onNavTap(i),
                    child: AnimatedBuilder(
                      animation: _itemControllers[i],
                      builder: (_, __) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // ── Icon with animated background ──
                            ScaleTransition(
                              scale: _scaleAnims[i],
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                padding: EdgeInsets.symmetric(
                                  horizontal: selected ? 16 : 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? item.color.withOpacity(0.15)
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(22),
                                ),
                                child: AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                          scale: anim, child: child),
                                  child: Icon(
                                    selected
                                        ? item.activeIcon
                                        : item.icon,
                                    key: ValueKey(selected),
                                    color: selected
                                        ? item.color
                                        : secondaryText,
                                    size: 23,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 3),

                            // ── Label ──────────────────────────
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                color: selected
                                    ? item.color
                                    : secondaryText,
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                letterSpacing:
                                    selected ? 0.3 : 0,
                              ),
                              child: Text(item.label),
                            ),

                            // ── Active dot ──────────────────────
                            const SizedBox(height: 2),
                            AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              width: selected ? 16 : 0,
                              height: selected ? 3 : 0,
                              decoration: BoxDecoration(
                                color: item.color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Nav item data ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
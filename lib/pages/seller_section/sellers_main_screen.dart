// lib/pages/seller/seller_main_screen.dart
import 'package:comfi/pages/sellers_menu_screen.dart';
import 'package:comfi/pages/sellers_dashboard_screen.dart';
import 'package:comfi/pages/seller_post_product_screen.dart';
import 'package:comfi/pages/sellers_shoppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    SellerDashboardScreen(),
    SellerShopPage(),
    SellerPostProductScreen(),
    SellerMenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _SellerBottomNav(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Seller Bottom Navigation — mirrors MyBottomNavigation design
// ─────────────────────────────────────────────────────────────────────────────
class _SellerBottomNav extends StatefulWidget {
  final void Function(int) onTabChange;
  final int selectedIndex;

  const _SellerBottomNav({
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  State<_SellerBottomNav> createState() => _SellerBottomNavState();
}

class _SellerBottomNavState extends State<_SellerBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<AnimationController> _rippleControllers;
  late List<Animation<double>>   _scaleAnimations;
  late List<Animation<double>>   _rippleAnimations;

  static const _primaryColor = Color(0xFF7C3AED);

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.storefront_outlined,
    Icons.add_circle_outline_rounded,
    Icons.menu_outlined,
  ];

  static const List<IconData> _activeIcons = [
    Icons.home_rounded,
    Icons.storefront_rounded,
    Icons.add_circle_rounded,
    Icons.menu_rounded,
  ];

  static const List<String> _labels = [
    'Home',
    'Shop',
    'Post',
    'Menu',
  ];

  @override
  void initState() {
    super.initState();

    _scaleControllers = List.generate(
      4,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 220),
        vsync: this,
      ),
    );

    _rippleControllers = List.generate(
      4,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 420),
        vsync: this,
      ),
    );

    _scaleAnimations = _scaleControllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.78), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 0.78, end: 1.16), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 1.16, end: 1.0), weight: 20),
      ]).animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();

    _rippleAnimations = _rippleControllers.map((c) {
      return Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _scaleControllers) c.dispose();
    for (final c in _rippleControllers) c.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (index == widget.selectedIndex) return;
    HapticFeedback.lightImpact();
    _scaleControllers[index].forward(from: 0.0);
    _rippleControllers[index].forward(from: 0.0);
    widget.onTabChange(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor       = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor   = isDark ? Colors.white.withOpacity(0.07) : const Color(0xFFE2E8F0);
    final inactiveColor = isDark ? Colors.white.withOpacity(0.35) : const Color(0xFF94A3B8);
    final shadowColor   = isDark
        ? Colors.black.withOpacity(0.4)
        : _primaryColor.withOpacity(0.12);
    final shadowColor2  = isDark
        ? Colors.black.withOpacity(0.2)
        : Colors.black.withOpacity(0.04);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: shadowColor,  blurRadius: 28, offset: const Offset(0, 8)),
          BoxShadow(color: shadowColor2, blurRadius: 8,  offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (i) => _buildItem(i, inactiveColor, isDark)),
        ),
      ),
    );
  }

  Widget _buildItem(int index, Color inactiveColor, bool isDark) {
    final isSelected = widget.selectedIndex == index;
    final isPost     = index == 2;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_scaleAnimations[index], _rippleAnimations[index]]),
        builder: (context, _) {
          return SizedBox(
            width: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon area ──────────────────────────────────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple burst
                    if (_rippleControllers[index].isAnimating)
                      Opacity(
                        opacity: (1 - _rippleAnimations[index].value) * 0.35,
                        child: Transform.scale(
                          scale: _rippleAnimations[index].value * 2.2,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: _primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                    // Animated pill background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width:  isSelected ? 54 : 36,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _primaryColor.withOpacity(isDark ? 0.18 : 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    // Icon — gradient circle for Post, regular icon for others
                    Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: isPost
                          ? Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF9333EA), Color(0xFF6366F1)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(
                                        isSelected ? 0.5 : 0.25),
                                    blurRadius: isSelected ? 14 : 6,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            )
                          : Icon(
                              isSelected ? _activeIcons[index] : _icons[index],
                              color: isSelected ? _primaryColor : inactiveColor,
                              size: isSelected ? 22 : 20,
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ── Label ──────────────────────────────────────────────
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize:   isSelected ? 11 : 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color:      isSelected ? _primaryColor : inactiveColor,
                    letterSpacing: isSelected ? 0.2 : 0,
                  ),
                  child: Text(_labels[index]),
                ),

                const SizedBox(height: 3),

                // ── Active dot ─────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width:  isSelected ? 16 : 0,
                  height: isSelected ? 3  : 0,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileBottomNavigation extends StatefulWidget {
  final void Function(int) onTabChange;
  final int selectedIndex;

  const MobileBottomNavigation({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  State<MobileBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MobileBottomNavigation>
    with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<AnimationController> _rippleControllers;
  late List<Animation<double>>   _scaleAnimations;
  late List<Animation<double>>   _rippleAnimations;

  static const _primaryColor = Color(0xFF8B5CF6);

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  final List<IconData> _activeIcons = [
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = [
    'Home',
    'Categories',
    'Cart',
    'Profile',
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

    _scaleAnimations = _scaleControllers
        .map((c) => TweenSequence<double>([
              TweenSequenceItem(
                  tween: Tween(begin: 1.0, end: 0.78), weight: 40),
              TweenSequenceItem(
                  tween: Tween(begin: 0.78, end: 1.16), weight: 40),
              TweenSequenceItem(
                  tween: Tween(begin: 1.16, end: 1.0), weight: 20),
            ]).animate(
                CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    _rippleAnimations = _rippleControllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
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

    // ── Theme-aware colors ──────────────────────────────
    final bgColor      = isDark
        ? const Color(0xFF111827)
        : Colors.white;
    final borderColor  = isDark
        ? Colors.white.withOpacity(0.07)
        : const Color(0xFFE2E8F0);
    final inactiveColor = isDark
        ? Colors.white.withOpacity(0.35)
        : const Color(0xFF94A3B8);
    final shadowColor  = isDark
        ? Colors.black.withOpacity(0.4)
        : const Color(0xFF8B5CF6).withOpacity(0.12);
    final shadowColor2 = isDark
        ? Colors.black.withOpacity(0.2)
        : Colors.black.withOpacity(0.04);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowColor2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            4,
            (index) => _buildItem(index, inactiveColor, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index, Color inactiveColor, bool isDark) {
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_scaleAnimations[index], _rippleAnimations[index]]),
        builder: (context, child) {
          return SizedBox(
            width: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Icon with pill + ripple ─────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple circle
                    if (_rippleControllers[index].isAnimating)
                      Opacity(
                        opacity: (1 - _rippleAnimations[index].value) * 0.35,
                        child: Transform.scale(
                          scale: _rippleAnimations[index].value * 2.2,
                          child: Container(
                            width: 36, height: 36,
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
                      width: isSelected ? 54 : 36,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _primaryColor.withOpacity(
                                isDark ? 0.18 : 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    // Icon with scale animation
                    Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: Icon(
                        isSelected
                            ? _activeIcons[index]
                            : _icons[index],
                        color: isSelected ? _primaryColor : inactiveColor,
                        size: isSelected ? 22 : 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ── Label ───────────────────────────────
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isSelected ? 11 : 10,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isSelected ? _primaryColor : inactiveColor,
                    letterSpacing: isSelected ? 0.2 : 0,
                  ),
                  child: Text(_labels[index]),
                ),

                const SizedBox(height: 3),

                // ── Active dot ──────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: isSelected ? 16 : 0,
                  height: isSelected ? 3 : 0,
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

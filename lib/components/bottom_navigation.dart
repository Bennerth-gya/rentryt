import 'package:comfi/layouts/app_shell_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({
    super.key,
    required this.destinations,
    required this.onTabChange,
    required this.selectedIndex,
  });

  final List<AppShellDestination> destinations;
  final void Function(int) onTabChange;
  final int selectedIndex;

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation>
    with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<AnimationController> _rippleControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rippleAnimations;

  static const _primaryColor = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant MyBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations.length != widget.destinations.length) {
      for (final controller in _scaleControllers) {
        controller.dispose();
      }
      for (final controller in _rippleControllers) {
        controller.dispose();
      }
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    _scaleControllers = List<AnimationController>.generate(
      widget.destinations.length,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 220),
        vsync: this,
      ),
    );

    _rippleControllers = List<AnimationController>.generate(
      widget.destinations.length,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 420),
        vsync: this,
      ),
    );

    _scaleAnimations = _scaleControllers
        .map(
          (controller) => TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween<double>(begin: 1, end: 0.8),
              weight: 40,
            ),
            TweenSequenceItem(
              tween: Tween<double>(begin: 0.8, end: 1.16),
              weight: 40,
            ),
            TweenSequenceItem(
              tween: Tween<double>(begin: 1.16, end: 1),
              weight: 20,
            ),
          ]).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOut),
          ),
        )
        .toList();

    _rippleAnimations = _rippleControllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOut),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _scaleControllers) {
      controller.dispose();
    }
    for (final controller in _rippleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (index == widget.selectedIndex) {
      return;
    }

    HapticFeedback.lightImpact();
    _scaleControllers[index].forward(from: 0);
    _rippleControllers[index].forward(from: 0);
    widget.onTabChange(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : const Color(0xFFE2E8F0);
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.38)
        : const Color(0xFF94A3B8);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.35)
        : const Color(0xFF8B5CF6).withValues(alpha: 0.12);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(
            widget.destinations.length,
            (index) => _buildItem(
              index: index,
              inactiveColor: inactiveColor,
              destination: widget.destinations[index],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required Color inactiveColor,
    required AppShellDestination destination,
  }) {
    final isSelected = widget.selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: Listenable.merge(
            [_scaleAnimations[index], _rippleAnimations[index]],
          ),
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_rippleControllers[index].isAnimating)
                      Opacity(
                        opacity: (1 - _rippleAnimations[index].value) * 0.35,
                        child: Transform.scale(
                          scale: _rippleAnimations[index].value * 2.2,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: _primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      width: isSelected ? 56 : 38,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _primaryColor.withValues(alpha: 0.14)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: Icon(
                        isSelected ? destination.activeIcon : destination.icon,
                        color: isSelected ? _primaryColor : inactiveColor,
                        size: isSelected ? 22 : 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    fontSize: isSelected ? 11.5 : 10.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? _primaryColor : inactiveColor,
                  ),
                  child: Text(
                    destination.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: isSelected ? 16 : 0,
                  height: isSelected ? 3 : 0,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

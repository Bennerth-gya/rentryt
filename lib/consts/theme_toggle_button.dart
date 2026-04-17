import 'package:comfi/consts/colors.dart';
import 'package:comfi/consts/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeToggleButton extends StatelessWidget {
  /// [surfaceColor] and [borderColor] come from the
  /// parent page's theme tokens so it blends in perfectly
  final Color surfaceColor;
  final Color borderColor;
  final double size;

  const ThemeToggleButton({
    super.key,
    required this.surfaceColor,
    required this.borderColor,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemeController>();

    return Obx(() {
      final dark = ctrl.isDark;
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          ctrl.toggleTheme();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(size * 0.3),
            border: Border.all(color: borderColor),
            // ✅ subtle violet glow in dark mode
            boxShadow: dark
                ? [
                    BoxShadow(
                      color: kViolet.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Icon(
              dark
                  ? Icons.light_mode_rounded      // sun — switch to light
                  : Icons.dark_mode_rounded,      // moon — switch to dark
              key: ValueKey(dark),
              color: dark ? kAccent : kViolet,
              size: size * 0.45,
            ),
          ),
        ),
      );
    });
  }
}

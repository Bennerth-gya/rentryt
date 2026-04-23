import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.gradient,
    this.borderColor,
    this.radius = 24,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double radius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor = color ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final resolvedBorderColor = borderColor ??
        (isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFE2E8F0));

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? resolvedColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: resolvedBorderColor),
        boxShadow: showShadow && !isDark
            ? [
                const BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 30,
                  offset: Offset(0, 16),
                ),
              ]
            : const [],
      ),
      child: child,
    );
  }
}

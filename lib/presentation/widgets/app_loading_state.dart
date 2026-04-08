import 'package:flutter/material.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({
    super.key,
    this.label = 'Loading...',
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Preparing the latest data for this screen.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppShellDestination {
  const AppShellDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
}

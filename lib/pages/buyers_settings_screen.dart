import 'package:comfi/pages/adaptive/large_screen_settings_screen.dart';
import 'package:comfi/pages/mobile/mobile_settings_screen.dart';
import 'package:comfi/widgets/adaptive/adaptive_layout.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileBuilder: (_) => const MobileSettingsScreen(),
      tabletBuilder: (_) => const LargeScreenSettingsScreen(),
      desktopBuilder: (_) => const LargeScreenSettingsScreen(),
    );
  }
}

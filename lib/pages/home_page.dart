import 'package:comfi/pages/adaptive/large_screen_home_page.dart';
import 'package:comfi/pages/mobile/mobile_home_page.dart';
import 'package:comfi/widgets/adaptive/adaptive_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileBuilder: (_) => const MobileHomePage(),
      tabletBuilder: (_) => const LargeScreenHomePage(),
      desktopBuilder: (_) => const LargeScreenHomePage(),
    );
  }
}

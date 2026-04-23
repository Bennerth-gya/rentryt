import 'package:comfi/pages/adaptive/large_screen_categories_screen.dart';
import 'package:comfi/pages/mobile/mobile_categories_screen.dart';
import 'package:comfi/widgets/adaptive/adaptive_layout.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileBuilder: (_) => const MobileCategoriesScreen(),
      tabletBuilder: (_) => const LargeScreenCategoriesScreen(),
      desktopBuilder: (_) => const LargeScreenCategoriesScreen(),
    );
  }
}

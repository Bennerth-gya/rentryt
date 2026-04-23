import 'package:comfi/pages/adaptive/large_screen_shop_page.dart';
import 'package:comfi/pages/mobile/mobile_shop_page.dart';
import 'package:comfi/widgets/adaptive/adaptive_layout.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileBuilder: (_) => const MobileShopPage(),
      tabletBuilder: (_) => const LargeScreenShopPage(),
      desktopBuilder: (_) => const LargeScreenShopPage(),
    );
  }
}

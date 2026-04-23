import 'package:comfi/core/widgets/double_back_to_exit_scope.dart';
import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';
import 'package:comfi/layouts/app_shell_destination.dart';
import 'package:comfi/layouts/buyer_responsive_shell.dart';
import 'package:comfi/pages/buyer_orders_screen.dart';
import 'package:comfi/pages/buyers_settings_screen.dart';
import 'package:comfi/pages/categories_screen.dart';
import 'package:comfi/pages/negotiation_chat_screen.dart';
import 'package:comfi/pages/shop_page.dart';
import 'package:flutter/material.dart';

class LargeScreenHomePage extends StatefulWidget {
  const LargeScreenHomePage({super.key});

  @override
  State<LargeScreenHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<LargeScreenHomePage> {
  int _selectedIndex = 0;
  late final List<AppShellDestination> _destinations;

  @override
  void initState() {
    super.initState();
    final featuredProduct = InMemorySeedData.buildProducts().first;

    _destinations = <AppShellDestination>[
      const AppShellDestination(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        page: ShopPage(),
      ),
      const AppShellDestination(
        label: 'Categories',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        page: CategoriesScreen(),
      ),
      const AppShellDestination(
        label: 'Orders',
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long_rounded,
        page: BuyerOrdersScreen(),
      ),
      AppShellDestination(
        label: 'Chat',
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_rounded,
        page: NegotiationChatScreen(
          routeData: NegotiationChatRouteData(
            product: featuredProduct,
            currentUser: InMemorySeedData.demoBuyer(),
          ),
          showBackButton: false,
        ),
      ),
      const AppShellDestination(
        label: 'Settings',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        page: SettingsScreen(),
      ),
    ];
  }

  void _handleDestinationSelected(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitScope(
      child: BuyerResponsiveShell(
        destinations: _destinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _handleDestinationSelected,
      ),
    );
  }
}

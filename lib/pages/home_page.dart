
import 'package:comfi/consts/app_theme.dart';
import 'package:comfi/consts/theme_toggle_button.dart' show ThemeToggleButton;
import 'package:comfi/models/cart.dart';
import 'package:comfi/pages/cart_page.dart';
import 'package:comfi/pages/categories_screen.dart';
import 'package:comfi/pages/profile_screen.dart';
import 'package:comfi/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:comfi/components/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _drawerAnimCtrl;
  late Animation<double> _drawerFade;

  final List<Widget> _pages = [
    const ShopPage(),
    const CategoriesScreen(),
    const CartPage(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _drawerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _drawerFade = CurvedAnimation(
        parent: _drawerAnimCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _drawerAnimCtrl.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.lightImpact();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    final cartCount =
        Provider.of<Cart>(context).userCart.length;

    return Scaffold(
      extendBody: true,
      backgroundColor: scaffoldBg,
      drawer: _ComfiDrawer(
        isDark: isDark,
        scaffoldBg: scaffoldBg,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        primaryText: primaryText,
        secondaryText: secondaryText,
        selectedIndex: _selectedIndex,
        onNavigate: (index) {
          Navigator.pop(context);
          _onTabChange(index);
        },
        fadeAnim: _drawerFade,
        onDrawerOpen: () => _drawerAnimCtrl.forward(from: 0),
      ),
      appBar: _selectedIndex == 0
          ? null // ShopPage has its own header
          : AppBar(
              backgroundColor: scaffoldBg,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    Scaffold.of(ctx).openDrawer();
                    _drawerAnimCtrl.forward(from: 0);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius:
                          BorderRadius.circular(12),
                      border:
                          Border.all(color: borderColor),
                    ),
                    child: Icon(Icons.menu_rounded,
                        color: primaryText, size: 20),
                  ),
                ),
              ),
              title: AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 250),
                child: Text(
                  _pageTitle(_selectedIndex),
                  key: ValueKey(_selectedIndex),
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              actions: [
                // Cart badge
                if (_selectedIndex != 2)
                  GestureDetector(
                    onTap: () => _onTabChange(2),
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 8),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                              border: Border.all(
                                  color: borderColor),
                            ),
                            child: Icon(
                              Icons
                                  .shopping_bag_outlined,
                              color: primaryText,
                              size: 20,
                            ),
                          ),
                          if (cartCount > 0)
                            Positioned(
                              top: -4, right: -4,
                              child: Container(
                                width: 18, height: 18,
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      Color(0xFF8B5CF6),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$cartCount',
                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Theme toggle
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16),
                  child: ThemeToggleButton(
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    size: 40,
                  ),
                ),
              ],
            ),

      bottomNavigationBar: MyBottomNavigation(
        onTabChange: _onTabChange,
        selectedIndex: _selectedIndex,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _pages[_selectedIndex],
        ),
      ),
    );
  }

  String _pageTitle(int index) {
    switch (index) {
      case 1: return 'Categories';
      case 2: return 'My Cart';
      case 3: return 'Profile';
      default: return 'Comfi';
    }
  }
}

// ── Comfi Drawer ──────────────────────────────────────────────────────────────
class _ComfiDrawer extends StatelessWidget {
  final bool isDark;
  final Color scaffoldBg;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;
  final int selectedIndex;
  final void Function(int) onNavigate;
  final Animation<double> fadeAnim;
  final VoidCallback onDrawerOpen;

  const _ComfiDrawer({
    required this.isDark,
    required this.scaffoldBg,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.selectedIndex,
    required this.onNavigate,
    required this.fadeAnim,
    required this.onDrawerOpen,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _DrawerItem(
        icon: Icons.home_rounded,
        label: 'Home',
        index: 0,
        color: const Color(0xFF8B5CF6),
      ),
      _DrawerItem(
        icon: Icons.grid_view_rounded,
        label: 'Categories',
        index: 1,
        color: const Color(0xFF06B6D4),
      ),
      _DrawerItem(
        icon: Icons.shopping_bag_rounded,
        label: 'Cart',
        index: 2,
        color: const Color(0xFFE83A8A),
      ),
      _DrawerItem(
        icon: Icons.person_rounded,
        label: 'Profile',
        index: 3,
        color: const Color(0xFF34D399),
      ),
    ];

    return Drawer(
      backgroundColor: scaffoldBg,
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: FadeTransition(
          opacity: fadeAnim,
          child: Column(
            children: [

              // ── Header ─────────────────────────────
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                    16, 16, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4C1D95),
                      Color(0xFF6D28D9),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Decorative orb
                    Positioned(
                      top: -20, right: -20,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                              .withOpacity(0.06),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Logo badge
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text('Comfi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text('shop with ease',
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.65),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Section label ───────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('NAVIGATION',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── Nav items ───────────────────────────
              ...items.map((item) => _DrawerTile(
                item: item,
                isSelected: selectedIndex == item.index,
                isDark: isDark,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onTap: () => onNavigate(item.index),
              )),

              const Spacer(),

              // ── Divider ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                child: Divider(color: borderColor),
              ),

              const SizedBox(height: 8),

              // ── Theme toggle row ────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6)
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.palette_rounded,
                        color: Color(0xFF8B5CF6),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text('Theme',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ThemeToggleButton(
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      size: 38,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Logout ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, 8),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444)
                          .withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFEF4444)
                            .withOpacity(0.18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFEF4444),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text('Logout',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Version ─────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 16),
                child: Text('Comfi v1.0.0',
                  style: TextStyle(
                    color: secondaryText
                        .withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drawer item data ──────────────────────────────────────────────────────────
class _DrawerItem {
  final IconData icon;
  final String label;
  final int index;
  final Color color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.color,
  });
}

// ── Drawer tile ───────────────────────────────────────────────────────────────
class _DrawerTile extends StatelessWidget {
  final _DrawerItem item;
  final bool isSelected;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 3),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? item.color.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? item.color.withOpacity(0.25)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 250),
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? item.color.withOpacity(0.15)
                      : isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFEEF1FB),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: isSelected
                      ? item.color
                      : secondaryText,
                  size: 20,
                ),
              ),

              const SizedBox(width: 14),

              // Label
              Expanded(
                child: Text(item.label,
                  style: TextStyle(
                    color: isSelected
                        ? item.color
                        : primaryText,
                    fontSize: 14.5,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),

              // Active dot
              if (isSelected)
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            item.color.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
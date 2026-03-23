
import 'package:comfi/models/cart.dart';
import 'package:comfi/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/theme_toggle_button.dart';
import 'seller_orders_screen.dart';
import 'seller_section/seller_earnings_screen.dart';
import 'seller_section/seller_profile_screen.dart';
import 'sellers_products/sellers_customers_screen.dart';
import 'sellers_products/sellers_products_screen.dart';
import 'sellers_products/sellers_statistics_screen.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() =>
      _SellerDashboardScreenState();
}

class _SellerDashboardScreenState
    extends State<SellerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
        parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart   = Provider.of<Cart>(context);

    // ── Theme tokens ────────────────────────────────────
    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── HERO HEADER ────────────────────────────
              SliverToBoxAdapter(
                child: _HeroHeader(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  onProfileTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const SellerProfileScreen()),
                  ),
                ),
              ),

              // ── STATS ROW ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 20, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Products',
                          value:
                              '${cart.sellerProducts.length}',
                          icon: Icons.inventory_2_rounded,
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          label: 'Orders',
                          value: '24',
                          icon: Icons.shopping_bag_rounded,
                          color: const Color(0xFF06B6D4),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          label: 'Revenue',
                          value: 'GHS\n1,260',
                          icon: Icons.attach_money_rounded,
                          color: const Color(0xFF34D399),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── SECTION LABEL ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 28, 16, 14),
                  child: Text('Quick access',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),

              // ── QUICK ACCESS GRID ──────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildListDelegate([
                    _QuickCard(
                      icon: Icons.people_rounded,
                      label: 'Customers',
                      subtitle: 'View all buyers',
                      color: const Color(0xFF8B5CF6),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const SellersCustomersScreen()),
                      ),
                    ),
                    _QuickCard(
                      icon: Icons.inventory_2_rounded,
                      label: 'Products',
                      subtitle: 'Manage listings',
                      color: const Color(0xFF06B6D4),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                SellersProductsScreen()),
                      ),
                    ),
                    _QuickCard(
                      icon: Icons.attach_money_rounded,
                      label: 'Earnings',
                      subtitle: 'Track revenue',
                      color: const Color(0xFF34D399),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const SellerEarningsScreen()),
                      ),
                    ),
                    _QuickCard(
                      icon: Icons.bar_chart_rounded,
                      label: 'Statistics',
                      subtitle: 'Sales analytics',
                      color: const Color(0xFFF59E0B),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const SellersStatisticsScreen()),
                      ),
                    ),
                    _QuickCard(
                      icon: Icons.receipt_long_rounded,
                      label: 'Orders',
                      subtitle: 'Recent orders',
                      color: const Color(0xFFE83A8A),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const SellerOrdersScreen()),
                      ),
                    ),
                    _QuickCard(
                      icon: Icons.local_mall_rounded,
                      label: 'Cart',
                      subtitle: 'View buyer cart',
                      color: const Color(0xFF8B5CF6),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CartPage()),
                      ),
                    ),
                  ]),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.35,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              ),

              // ── OVERVIEW SECTION ───────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      16, 28, 16, 14),
                  child: Text('Overview',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _OverviewCard(
                      title: 'Total Orders',
                      value: '24',
                      subtitle: '+3 from yesterday',
                      icon: Icons.shopping_bag_rounded,
                      color: const Color(0xFF8B5CF6),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 12),
                    _OverviewCard(
                      title: 'Total Revenue',
                      value: 'GHS 1,260.40',
                      subtitle: '+GHS 240 today',
                      icon: Icons.attach_money_rounded,
                      color: const Color(0xFF34D399),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 12),
                    _OverviewCard(
                      title: 'Active Customers',
                      value: '18',
                      subtitle: '2 new this week',
                      icon: Icons.people_rounded,
                      color: const Color(0xFF06B6D4),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero header ───────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onProfileTap;

  const _HeroHeader({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C1D95),
            Color(0xFF6D28D9),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -10, left: -30,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top row ─────────────────────────────
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting + name
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Good evening 👋',
                        style: TextStyle(
                          color:
                              Colors.white.withOpacity(0.65),
                          fontSize: 13,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text('Bennerth',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  // ✅ Toggle + profile avatar
                  Row(
                    children: [
                      // Theme toggle — white-tinted to
                      // blend with the violet gradient
                      ThemeToggleButton(
                        surfaceColor:
                            Colors.white.withOpacity(0.15),
                        borderColor:
                            Colors.white.withOpacity(0.25),
                        size: 42,
                      ),
                      const SizedBox(width: 10),

                      // Profile avatar
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Sales card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text("Today's sales",
                            style: TextStyle(
                              color:
                                  Colors.white.withOpacity(0.65),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text('GHS 1,260.40',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF34D399)
                                      .withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Icon(
                                        Icons
                                            .trending_up_rounded,
                                        color:
                                            Color(0xFF34D399),
                                        size: 12),
                                    SizedBox(width: 4),
                                    Text('+12% today',
                                      style: TextStyle(
                                        color:
                                            Color(0xFF34D399),
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: const Icon(
                          Icons.attach_money_rounded,
                          color: Colors.white,
                          size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Location pill
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Colors.white54, size: 13),
                  const SizedBox(width: 4),
                  Text('Huni Valley, Ghana',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.08 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(value,
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : const Color(0xFF0F172A),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.4)
                  : const Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick access card ─────────────────────────────────────────────────────────
class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color:
                  color.withOpacity(isDark ? 0.08 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: color, size: 13),
                ),
              ],
            ),
            const Spacer(),
            Text(label,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(subtitle,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.4)
                    : const Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Overview card ─────────────────────────────────────────────────────────────
class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color:
                color.withOpacity(isDark ? 0.06 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(value,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF34D399).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(subtitle,
              style: const TextStyle(
                color: Color(0xFF34D399),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
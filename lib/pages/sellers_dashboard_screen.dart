import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/pages/cart_page.dart';
import 'package:flutter/material.dart';

import 'seller_orders_screen.dart';
import 'seller_section/seller_earnings_screen.dart';
import 'seller_section/seller_profile_screen.dart';
import 'sellers_products/sellers_customers_screen.dart';
import 'sellers_products/sellers_products_screen.dart';
import 'sellers_products/sellers_statistics_screen.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Top greeting + today sales (hero style)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6B4EFF),
                    const Color(0xFF4A63F6).withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Bennerth!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Good evening • Accra",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // ── Make CircleAvatar tappable ────────────────────────────────
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SellerProfileScreen(), // ← your profile screen
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Today Sales",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "GHS 1,260.40", // ← make dynamic later
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Quick access cards
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: [
                        _quickCard(Icons.people, "Customers", () {
                          // Navigate to My Customers screen (create this if not already done)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SellersCustomersScreen(), // ← define this screen
                            ),
                          );
                        }),
                        _quickCard(Icons.inventory_2, "Products", () {
                          // Navigate to My Products screen (create this if not already done)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SellersProductsScreen(), // ← define this screen
                            ),
                          );
                        }),
                        _quickCard(Icons.attach_money, "Revenue", () {
                          // Navigate to Earnings screen (you already have this in menu)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SellerEarningsScreen(),
                            ),
                          );
                        }),
                        _quickCard(Icons.bar_chart, "Statistics", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SellersStatisticsScreen(), // or SellerStatsScreen()
                            ),
                          );
                          // Better: if using tabs, you can use DefaultTabController.of(context).animateTo(1);
                          // But since it's a different Scaffold, better to have a dedicated screen
                        }),
                        _quickCard(Icons.shopping_cart, "Orders", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SellerOrdersScreen(), // or SellerOrdersScreen()
                            ),
                          );
                          // Better: if using tabs, you can use DefaultTabController.of(context).animateTo(1);
                          // But since it's a different Scaffold, better to have a dedicated screen
                        }),
                        _quickCard(Icons.local_mall, "Cart", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CartPage(), // or SellerOrdersScreen()
                            ),
                          );
                          // Better: if using tabs, you can use DefaultTabController.of(context).animateTo(1);
                          // But since it's a different Scaffold, better to have a dedicated screen
                        }),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Keep your existing analytics / orders / earnings sections here
                    // or move them below as secondary content
                    _buildOverview(), // ← your current overview content
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation like in the image
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: cardColor,
      //   selectedItemColor: const Color(0xFF6B4EFF),
      //   unselectedItemColor: Colors.white70,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.history), label: "Orders"),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: "Notifications",
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      //   currentIndex: 0, // make dynamic with state
      //   onTap: (index) {
      //     // handle navigation
      //   },
      // ),
    );
  }

  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Overview",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _analyticsCard("Total Orders", "24", Icons.shopping_bag),
      ],
    );
  }

  static Widget _quickCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF6B4EFF), size: 40),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward, color: Color(0xFF6B4EFF), size: 20),
          ],
        ),
      ),
    );
  }
}

/// -------------------------
/// ANALYTICS CARD
/// -------------------------
Widget _analyticsCard(String title, String value, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF6B4EFF), size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

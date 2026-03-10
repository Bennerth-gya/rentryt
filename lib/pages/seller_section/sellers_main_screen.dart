import 'package:comfi/consts/colors.dart';
import 'package:comfi/pages/shop_page.dart';
import 'package:flutter/material.dart';

import '../products/my_products_screen.dart';
import '../seller_post_product_screen.dart';
import '../sellers_dashboard_screen.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ShopPage(),
    const MyProductsScreen(),
    const SellerPostProductScreen(),
    const SellerDashboardScreen(),
  ];

  /// Drawer item widget
  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      /// DRAWER MENU
      drawer: Drawer(
        backgroundColor: cardColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6B4EFF)),
              child: Text(
                "Seller Panel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _drawerItem(Icons.shopping_cart, "Shop", 0),
            _drawerItem(Icons.inventory, "My Products", 1),
            _drawerItem(Icons.add_box, "Post Product", 2),
            _drawerItem(Icons.analytics, "Dashboard", 3),
          ],
        ),
      ),

      /// MAIN BODY
      body: _pages[_selectedIndex],

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF6B4EFF),
        unselectedItemColor: Colors.grey,
        backgroundColor: cardColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'My Products',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Post'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

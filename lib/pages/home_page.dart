import 'dart:async';

import 'package:flutter/material.dart';

import 'package:comfi/components/bottom_navigation.dart';
import 'package:comfi/pages/cart_page.dart';
import 'package:comfi/pages/categories_screen.dart';
import 'package:comfi/pages/profile_screen.dart';
import 'package:comfi/pages/shop_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // selected index of bottom navigation bar
  int _selectedIndex = 0;

  // this method will update the selected index
  // when our tab is changed
  void navigationBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to be displayed on each tab
  final List<Widget> _pages = [
    // home page
    const ShopPage(),

    // categories
    const CategoriesScreen(),

    // cart page
    const CartPage(),
    // profile page
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavigation(
        onTabChange: navigationBottomBar,
        selectedIndex: _selectedIndex,
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: Colors.grey[900],

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // logo
                DrawerHeader(child: Image.asset('lib/images/company1.png')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(color: Colors.grey[800]),
                ),

                // other pages
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text('Home', style: TextStyle(color: Colors.white)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.white),
                    title: Text('About', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

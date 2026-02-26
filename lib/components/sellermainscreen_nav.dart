// lib/pages/seller/seller_main_screen.dart
import 'package:comfi/consts/colors.dart';
import 'package:comfi/pages/become_a_seller_dashboard.dart';
//import 'package:comfi/pages/seller/seller_dashboard_screen.dart'; // your dashboard
//import 'package:comfi/pages/seller/seller_orders_screen.dart';   // your orders page
import 'package:comfi/pages/seller_orders_screen.dart';
import 'package:flutter/material.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SellerDashboardScreen(), // index 0
    SellerOrdersScreen(), // index 1 - My Orders
    Center(
      child: Text(
        "Refund Page - Coming Soon",
        style: TextStyle(color: Colors.white),
      ),
    ),
    Center(
      child: Text(
        "Menu / Settings - Coming Soon",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cardColor,
        selectedItemColor: const Color(0xFF6B4EFF),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "My Order",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "Refund"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }
}

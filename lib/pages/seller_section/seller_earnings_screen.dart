// lib/pages/seller_section/seller_settings_screen.dart
import 'package:flutter/material.dart';
import '../../consts/colors.dart';

class SellerEarningsScreen extends StatelessWidget {
  const SellerEarningsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: const Text("Sellers Earnings")),
      body: const Center(
        child: Text(
          "Sellers Earnings Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

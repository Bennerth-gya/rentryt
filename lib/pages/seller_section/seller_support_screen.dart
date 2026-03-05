// lib/pages/seller_section/seller_settings_screen.dart
import 'package:flutter/material.dart';
import '../../consts/colors.dart';

class SellerSupportScreen extends StatelessWidget {
  const SellerSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: const Text("Seller Support")),
      body: const Center(
        child: Text("Support Page", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

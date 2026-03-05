// lib/pages/seller_section/seller_settings_screen.dart
import 'package:flutter/material.dart';
import '../../consts/colors.dart';

class SellerSettingsScreen extends StatelessWidget {
  const SellerSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(
        child: Text("Settings Page", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// lib/pages/seller/seller_post_product_screen.dart
import 'package:flutter/material.dart';

class SellerPostProductScreen extends StatelessWidget {
  const SellerPostProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text("Post a Product")),
      ),
      body: const Center(
        child: Text(
          "Product upload form goes here...\nTitle, Price, Images, Description, etc.",
        ),
      ),
    );
  }
}

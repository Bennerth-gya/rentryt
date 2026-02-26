import 'package:comfi/components/sellermainscreen_nav.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/pages/become_a_seller_dashboard.dart';
import 'package:flutter/material.dart';
// You can import your SellerMainScreen here later when you create it
// import 'package:comfi/pages/seller/seller_main_screen.dart';

class BecomeSellerScreen extends StatefulWidget {
  const BecomeSellerScreen({super.key});

  @override
  State<BecomeSellerScreen> createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  String shopName = '';
  String phone = '';
  String location = 'Tarkwa, Ghana'; // default based on your app context
  String description = '';

  bool _isSubmitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate processing

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Seller account created! Welcome to your dashboard."),
        backgroundColor: Colors.green,
      ),
    );

    // For now: navigate to a placeholder seller dashboard
    // Later replace with your real SellerMainScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SellerMainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Become a Seller on Comfi"),
        backgroundColor: background,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Start Selling Today",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Reach customers in Tarkwa and across Ghana with your products.",
                  style: TextStyle(color: textSecondary, fontSize: 15),
                ),
                const SizedBox(height: 32),

                // Shop Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Shop Name",
                    hintText: "e.g. Bennerth Fashion Hub",
                    hintStyle: const TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: cardColor,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Shop name is required"
                      : null,
                  onSaved: (value) => shopName = value!.trim(),
                ),
                const SizedBox(height: 20),

                // Phone Number
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Phone Number (WhatsApp preferred)",
                    hintText: "e.g. +233 24 123 4567",
                    hintStyle: const TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: cardColor,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.length < 9
                      ? "Enter a valid phone number"
                      : null,
                  onSaved: (value) => phone = value!.trim(),
                ),
                const SizedBox(height: 20),

                // Location
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Location",
                    hintText: "e.g. Market Street, Tarkwa",
                    hintStyle: const TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: cardColor,
                  ),
                  onSaved: (value) => location = value?.trim() ?? location,
                ),
                const SizedBox(height: 20),

                // Description
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "About your shop",
                    hintText: "Tell customers what you sell...",
                    hintStyle: const TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: cardColor,
                  ),
                  maxLines: 4,
                  onSaved: (value) => description = value?.trim() ?? '',
                ),
                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Icon(Icons.storefront),
                    label: Text(
                      _isSubmitting ? "Processing..." : "Create Seller Account",
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4EFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                  ),
                ),

                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Your application will be reviewed shortly.\nYou can start adding products once approved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

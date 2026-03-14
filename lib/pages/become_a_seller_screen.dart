// lib/pages/become_a_seller_screen.dart
import 'package:comfi/consts/colors.dart';
import 'package:flutter/material.dart';
import 'seller_section/sellers_main_screen.dart';

class BecomeSellerScreen extends StatefulWidget {
  const BecomeSellerScreen({super.key});

  @override
  State<BecomeSellerScreen> createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
  final _formKey = GlobalKey<FormState>();

  String shopName = '';
  String phone = '';
  String location = 'Tarkwa, Ghana';
  String description = '';

  bool _isSubmitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Seller account created! Welcome to your dashboard."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SellerMainScreen()),
    );
  }

  InputDecoration inputStyle(String label, String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            /// TOP HERO SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B4EFF), Color(0xFF8E7BFF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Become a Seller",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Start selling your products on Comfi",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            /// FORM SECTION
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// Shop Name
                        TextFormField(
                          style: whiteInputStyle,
                          decoration: inputStyle(
                            "Shop Name",
                            "Bennerth Fashion Hub",
                            Icons.store,
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? "Shop name is required"
                              : null,
                          onSaved: (value) => shopName = value!.trim(),
                        ),

                        const SizedBox(height: 18),

                        /// Phone
                        TextFormField(
                          style: whiteInputStyle,
                          decoration: inputStyle(
                            "Phone Number",
                            "+233 24 123 4567",
                            Icons.phone,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value == null || value.length < 9
                              ? "Enter a valid phone number"
                              : null,
                          onSaved: (value) => phone = value!.trim(),
                        ),

                        const SizedBox(height: 18),

                        /// Location
                        TextFormField(
                          style: whiteInputStyle,
                          decoration: inputStyle(
                            "Location",
                            "Market Street, Tarkwa",
                            Icons.location_on,
                          ),
                          onSaved: (value) =>
                              location = value?.trim() ?? location,
                        ),

                        const SizedBox(height: 18),

                        /// Description
                        TextFormField(
                          style: whiteInputStyle,
                          maxLines: 4,
                          decoration: inputStyle(
                            "About your shop",
                            "Tell customers what you sell...",
                            Icons.info,
                          ),
                          onSaved: (value) => description = value?.trim() ?? '',
                        ),

                        const SizedBox(height: 30),

                        /// SUBMIT BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B4EFF),
                              elevation: 8,
                              shadowColor: const Color(0xFF6B4EFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Create Seller Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Your application will be reviewed shortly.\nYou can start adding products once approved.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

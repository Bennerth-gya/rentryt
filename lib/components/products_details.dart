import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/payment/payment_method.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final Products product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? _selectedColor;
  String? _selectedSize;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Default to first color/size if available
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        double starValue = index + 1;
        return Icon(
          starValue <= rating
              ? Icons.star
              : starValue - 0.5 <= rating
              ? Icons.star_half
              : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Future<void> _simulateBuyNow() async {
    if (_selectedSize == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select size and color first")),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 3));

    final bool success = DateTime.now().millisecond % 10 < 7;

    setState(() => _isProcessing = false);
    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
          title: const Text("Payment Successful!"),
          content: Text(
            "Thank you! Your order for ${widget.product.name}\n"
            "(Color: $_selectedColor • Size: $_selectedSize)\n"
            "has been placed successfully.\n\n"
            "Order reference: CMP-${DateTime.now().millisecondsSinceEpoch}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // back to previous screen
              },
              child: const Text("View Order"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Continue Shopping"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Payment declined. Please try again or use another method.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _simulateAddToCart() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.product.name} added to cart!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: cardColor,
        foregroundColor: textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    "GHC ${product.price != null ? product.price!.toStringAsFixed(2) : 'N/A'}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating
                  if (product.averageRating != null &&
                      product.reviewCount != null) ...[
                    Row(
                      children: [
                        _buildStarRating(product.averageRating!),
                        const SizedBox(width: 8),
                        Text(
                          "${product.averageRating!.toStringAsFixed(1)} • ${product.reviewCount} reviews",
                          style: TextStyle(color: textSecondary, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Color Selection ───────────────────────────────────────
                  if (product.colors.isNotEmpty) ...[
                    const Text(
                      "Color",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.colors.length,
                        itemBuilder: (context, index) {
                          final colorHex = product.colors[index];
                          final color = Color(
                            int.parse(colorHex.replaceFirst('#', '0xFF')),
                          );
                          final isSelected = _selectedColor == colorHex;

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedColor = colorHex);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: isSelected
                                    ? Border.all(color: accent, width: 3)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── Size Selection ────────────────────────────────────────
                  if (product.sizes.isNotEmpty) ...[
                    const Text(
                      "Size",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: product.sizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedSize = size);
                          },
                          selectedColor: accent,
                          backgroundColor: cardColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : textPrimary,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Description
                  Text(
                    product.description ?? "No description available.",
                    style: TextStyle(
                      fontSize: 16,
                      color: textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Action Buttons ────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _simulateAddToCart,
                          icon: Icon(Icons.add_shopping_cart, color: accent),
                          label: const Text("Add to Cart"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: accent),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Inside the build method, replace the ElevatedButton for "Buy Now"
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  // validate selections first
                                  if (_selectedSize == null ||
                                      _selectedColor == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please select size and color first",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentMethod(),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.payment, color: Colors.white),
                          label: const Text(
                            "Buy Now",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Customer Reviews Section (your existing code can go here)
                  const Text(
                    "Customer Reviews",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // ... add your reviews rendering logic here ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

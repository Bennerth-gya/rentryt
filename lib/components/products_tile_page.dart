import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/products.dart';
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
            // Hero image (you can later swap based on selected color)
            AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(product.imagePath, fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // Rating row
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

                  // Color selection
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
                            onTap: () =>
                                setState(() => _selectedColor = colorHex),
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

                  // Size selection
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
                          onSelected: (_) =>
                              setState(() => _selectedSize = size),
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

                  // Add to Cart button (you can disable if no size/color selected)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed:
                          (_selectedSize != null && _selectedColor != null)
                          ? () {
                              // TODO: Add variant logic + cart
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Added to cart!")),
                              );
                            }
                          : null,
                      icon: Icon(Icons.add_shopping_cart, color: accent),
                      label: Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 17, color: accent),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Customer Reviews Section
                  const Text(
                    "Customer Reviews",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (product.reviews != null &&
                      product.reviews!.isNotEmpty) ...[
                    ...product.reviews!.take(3).map((review) {
                      // Show first 3
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _buildStarRating(review.rating),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(review.comment),
                              const SizedBox(height: 4),
                              Text(
                                review.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (product.reviews!.length > 3)
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to full reviews page
                        },
                        child: const Text("See all reviews"),
                      ),
                  ] else ...[
                    Text(
                      "No reviews yet. Be the first to review!",
                      style: TextStyle(color: textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

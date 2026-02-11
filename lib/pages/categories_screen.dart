import 'package:flutter/material.dart';
import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All',
    'Electronics',
    'Education',
    'Men',
    'Ladies',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('CATEGORIES'),
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chips (horizontal scroll) - unchanged
            SizedBox(
              height: 48,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedCategoryIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(_categories[index]),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      backgroundColor: isSelected
                          ? const Color(0xFF6B4EFF)
                          : Colors.grey.shade200,
                      selectedColor: const Color(0xFF6B4EFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      showCheckmark: false,
                      onSelected: (value) {
                        setState(() => _selectedCategoryIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _selectedCategoryIndex == 0
                    ? "Explore Our Collection"
                    : "Best ${_categories[_selectedCategoryIndex]}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            const SizedBox(height: 16),

            // Products grid – match ShopPage style & spacing
            Expanded(
              child: Consumer<Cart>(
                builder: (context, cart, child) {
                  final selectedCategory = _categories[_selectedCategoryIndex];
                  final products = cart.getProductsForCategory(
                    selectedCategory,
                  );

                  if (products.isEmpty) {
                    return const Center(
                      child: Text("No products in this category yet"),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            0.50, // ← key fix: use a value that works in ShopPage
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24, // ← more vertical breathing room
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductsTile(
                          product: product,
                          onTap: () => _addToCart(product),
                          isInGrid: true,
                          showAddButton: true,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Products product) {
    Provider.of<Cart>(context, listen: false).addItemToCart(product);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${product.name} added to cart")));
  }
}

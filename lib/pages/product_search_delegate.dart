import 'package:flutter/material.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/components/products_tile.dart';
import 'package:provider/provider.dart';

class ProductSearchDelegate extends SearchDelegate<Products?> {
  final Cart cart;

  ProductSearchDelegate({required this.cart});

  // This controls the theme of the entire search page
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      // This sets the background behind everything (most important)
      scaffoldBackgroundColor: background,

      // Search bar / AppBar styling
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor, // or background if you prefer same color
        elevation: 10,
        iconTheme: IconThemeData(color: textPrimary),
        actionsIconTheme: IconThemeData(color: textPrimary),
        toolbarTextStyle: TextStyle(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Input field styling
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: textSecondary),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),

      // Text colors in suggestions/results
      textTheme: theme.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          "Start typing to search products",
          style: TextStyle(color: textSecondary, fontSize: 16),
        ),
      );
    }

    final results = cart.searchProducts(query);

    if (results.isEmpty) {
      return Center(
        child: Text(
          "No products found",
          style: TextStyle(color: textSecondary, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 5,
        mainAxisSpacing: 24,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ProductsTile(
          product: product,
          onAddToCart: () {
            Provider.of<Cart>(context, listen: false).addItemToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${product.name} added to cart"),
                backgroundColor: Colors.green.shade700,
              ),
            );
          },
          isInGrid: true,
        );
      },
    );
  }
}

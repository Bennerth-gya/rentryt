import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/pages/become_a_seller_screen.dart';
import 'package:comfi/pages/product_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _currentBanner = 0;

  void _openSearch() {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(
        cart: Provider.of<Cart>(context, listen: false),
      ),
    );
  }

  void addProductToCart(Products product) {
    Provider.of<Cart>(context, listen: false).addItemToCart(product);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Added successfully"),
        content: const Text("Check your cart."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Banner items – update paths to match your pubspec.yaml assets
  final List<Map<String, String>> bannerItems = [
    {
      'image': 'assets/images/black_man.jpg',
      'title': 'New Collection',
      'subtitle': 'Up to 50% Off',
    },
    {
      'image': 'assets/images/beautiful_dark_shopping.jpg',
      'title': 'Summer Sale',
      'subtitle': 'Fresh Styles Await',
    },
    {
      'image': 'assets/images/dark_lady_shopping.jpg',
      'title': 'Limited Stock',
      'subtitle': 'Grab Now!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, _) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isTablet = width >= 600;
                final isDesktop = width >= 1000;
                final horizontalPadding = isDesktop
                    ? 200.0
                    : isTablet
                    ? 60.0
                    : 25.0;

                final bannerHeight = isDesktop
                    ? 420.0
                    : isTablet
                    ? 360.0
                    : 280.0;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ================= HEADER =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 25,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hi Systrom,",
                                      style: TextStyle(
                                        fontSize: isDesktop
                                            ? 28
                                            : isTablet
                                            ? 24
                                            : 22,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Find what you need in Tarkwa!",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Notifications
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.notifications_none,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Become Seller button
                                    OutlinedButton.icon(
                                      icon: const Icon(
                                        Icons.storefront,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        "Sell",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF6B4EFF),
                                        ),
                                        foregroundColor: const Color(
                                          0xFF6B4EFF,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BecomeSellerScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ================= SEARCH + FILTER =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _openSearch,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.search,
                                            color: textSecondary,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "Search products...",
                                            style: TextStyle(
                                              color: textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.tune,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ... rest of your code remains unchanged ...
                          const SizedBox(height: 25),

                          // HERO CAROUSEL
                          // Featured Products
                          // Recommended Section
                          // (I've omitted repeating the full long code here to save space)
                          // Everything below the header stays exactly as you had it
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

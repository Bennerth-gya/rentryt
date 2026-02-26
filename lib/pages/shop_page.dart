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
                    : 20.0;
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
                              vertical: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // LEFT - Greeting
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi Systrom,",
                                        style: TextStyle(
                                          fontSize: isDesktop
                                              ? 28
                                              : isTablet
                                              ? 24
                                              : 20,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Find what you need in Tarkwa!",
                                        style: TextStyle(
                                          fontSize: isTablet ? 15 : 13,
                                          color: textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // RIGHT - Actions
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.loose,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.notifications_none,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        icon: const Icon(
                                          Icons.storefront,
                                          size: 14,
                                        ),
                                        label: const Text(
                                          "Sell",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xFF6B4EFF),
                                          ),
                                          foregroundColor: const Color(
                                            0xFF6B4EFF,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
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
                                ),
                              ],
                            ),
                          ),

                          // ================= SEARCH =================
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
                                  child: const Icon(Icons.tune),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ================= CAROUSEL =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: bannerHeight,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: isDesktop
                                    ? 0.7
                                    : isTablet
                                    ? 0.8
                                    : 0.92,
                                onPageChanged: (index, reason) {
                                  setState(() => _currentBanner = index);
                                },
                              ),
                              items: bannerItems.map((banner) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    banner['image']!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // ================= FEATURED =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: const Text(
                              "Featured Products",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isDesktop
                                        ? 4
                                        : isTablet
                                        ? 3
                                        : 2,
                                    childAspectRatio: 0.45,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 19,
                                  ),
                              itemCount: cart.getFeaturedList().length,
                              itemBuilder: (context, index) {
                                final product = cart.getFeaturedList()[index];
                                return ProductsTile(
                                  product: product,
                                  onAddToCart: () => addProductToCart(product),
                                  isInGrid: true,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 60),
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

import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
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
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.notifications_none),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.location_on, size: 18),
                                        SizedBox(width: 8),
                                        Text("Tarkwa"),
                                        Spacer(),
                                        Icon(Icons.search),
                                      ],
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

                          // ================= HERO BANNER =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Container(
                              height: isDesktop
                                  ? 420
                                  : isTablet
                                  ? 360
                                  : 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CarouselSlider(
                                      options: CarouselOptions(
                                        height: double.infinity,
                                        viewportFraction: 1.0,
                                        autoPlay: true,
                                        autoPlayInterval: const Duration(
                                          seconds: 5,
                                        ),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 1200),
                                        autoPlayCurve: Curves.easeInOutCubic,
                                        enlargeCenterPage: false,
                                        enableInfiniteScroll: true,
                                      ),
                                      items:
                                          [
                                            'lib/images/smart-shopping-tips.jpg',
                                            'lib/images/dark_lady_shopping.jpg',
                                            'lib/images/beautiful_dark_shopping.jpg',
                                            'lib/images/black_man.jpg',
                                          ].map((imagePath) {
                                            return Image.asset(
                                              imagePath,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            );
                                          }).toList(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.15),
                                            Colors.black.withOpacity(0.65),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isDesktop
                                              ? 60
                                              : isTablet
                                              ? 40
                                              : 28,
                                          vertical: isDesktop
                                              ? 40
                                              : isTablet
                                              ? 32
                                              : 24,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Shopping doesn't get any easier and better than this",
                                              style: TextStyle(
                                                fontSize: isDesktop
                                                    ? 38
                                                    : isTablet
                                                    ? 32
                                                    : 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                height: 1.15,
                                                letterSpacing: -0.5,
                                                shadows: const [
                                                  Shadow(
                                                    blurRadius: 6,
                                                    color: Colors.black87,
                                                    offset: Offset(2, 2),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 32),
                                            ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.explore,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                "Start Shopping",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                foregroundColor: accent,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                elevation: 6,
                                                minimumSize: const Size(
                                                  220,
                                                  56,
                                                ),
                                              ),
                                              onPressed: () {
                                                // Optional: scroll to featured or navigate
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // ================= FEATURED PRODUCTS =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: const Text(
                              "Featured Products",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: isTablet
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 0.75,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                    itemCount: cart.getFeaturedList().length,
                                    itemBuilder: (context, index) {
                                      final product = cart
                                          .getFeaturedList()[index];
                                      return ProductsTile(
                                        shoe:
                                            product, // ← rename to product later
                                        onTap: () => addProductToCart(product),
                                        isInGrid: true,
                                      );
                                    },
                                  )
                                : SizedBox(
                                    height: 280,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cart.getFeaturedList().length,
                                      itemBuilder: (context, index) {
                                        final product = cart
                                            .getFeaturedList()[index];
                                        return ProductsTile(
                                          shoe: product,
                                          onTap: () =>
                                              addProductToCart(product),
                                          isInGrid: false,
                                        );
                                      },
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 40),

                          // ================= RECOMMENDED SECTION =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recommended For You",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to full list / search page
                                  },
                                  child: const Text(
                                    "View All",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

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
                                    childAspectRatio: 0.68,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 20,
                                  ),
                              itemCount: cart.getRecommendedList().length,
                              itemBuilder: (context, index) {
                                final product = cart
                                    .getRecommendedList()[index];
                                return ProductsTile(
                                  shoe: product,
                                  onTap: () => addProductToCart(product),
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

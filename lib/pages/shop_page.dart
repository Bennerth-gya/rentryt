import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
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
  // Recommended: use 'assets/images/...' (not 'lib/images/...')
  final List<Map<String, String>> bannerItems = [
    {
      'image': 'lib/images/black_man.jpg',
      'title': 'New Collection',
      'subtitle': 'Up to 50% Off',
    },
    {
      'image': 'lib/images/beautiful_dark_shopping.jpg',
      'title': 'Summer Sale',
      'subtitle': 'Fresh Styles Await',
    },
    {
      'image': 'lib/images/dark_lady_shopping.jpg',
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

                          // ================= HERO CAROUSEL =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: bannerHeight,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(
                                      seconds: 5,
                                    ),
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 800,
                                    ),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.22,
                                    viewportFraction: isDesktop
                                        ? 0.70
                                        : isTablet
                                        ? 0.80
                                        : 0.92,
                                    aspectRatio: 16 / 9,
                                    enableInfiniteScroll: true,
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    padEnds: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentBanner = index;
                                      });
                                    },
                                  ),
                                  items: bannerItems.map((banner) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage(
                                                banner['image']!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.55),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    24.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        banner['title']!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 4,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        banner['subtitle']!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 3,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // TODO: handle banner tap (e.g. navigate to category)
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          foregroundColor:
                                                              Colors.black87,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 24,
                                                                vertical: 12,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  30,
                                                                ),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "Shop Now",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 16),

                                // Dynamic dots indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: bannerItems.asMap().entries.map((
                                    entry,
                                  ) {
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentBanner == entry.key
                                            ? Colors
                                                  .redAccent // active dot
                                            : Colors.grey.withOpacity(
                                                0.5,
                                              ), // inactive
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // <<<----------------- FEATURED PRODUCTS --------------->>>
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
                                          crossAxisCount: 2,
                                          childAspectRatio:
                                              0.78, // I will try and add the payment section today,ok,  can I call you? are yyyyyyyou my girlfriend? Haha you get one now?es, tomorrow, you will get one tomorrow?
                                          crossAxisSpacing:
                                              12, // her tomorrow type within the comment oo senior memp3 as3m biaa
                                          mainAxisSpacing: 16,
                                        ),

                                    itemCount: cart.getFeaturedList().length,
                                    itemBuilder: (context, index) {
                                      final product = cart
                                          .getFeaturedList()[index];
                                      return ProductsTile(
                                        product: product,
                                        onAddToCart: () => addProductToCart(
                                          product,
                                        ), // renamed
                                        isInGrid: true,
                                      );
                                    },
                                  )
                                : SizedBox(
                                    height: 220,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cart.getFeaturedList().length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 12),
                                      itemBuilder: (context, index) {
                                        final product = cart
                                            .getFeaturedList()[index];

                                        return Container(
                                          width: 160,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1E293B),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.asset(
                                                    product.imagePath,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "\$${product.price}",
                                                style: const TextStyle(
                                                  color: Color(0xFF8B5CF6),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 40),

                          // <<<------------- RECOMMENDED SECTION ----------->>>
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
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // <<-------TODO: Navigate to full list / search page---->>>
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
                                    childAspectRatio: 0.50,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 24,
                                  ),
                              itemCount: cart.getRecommendedList().length,
                              itemBuilder: (context, index) {
                                final product = cart
                                    .getRecommendedList()[index];
                                // <<------- calls the productstile section------>>>
                                return ProductsTile(
                                  product: product,
                                  onAddToCart: () =>
                                      addProductToCart(product), // renamed
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

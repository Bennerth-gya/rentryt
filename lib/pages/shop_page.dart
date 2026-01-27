import 'package:comfi/components/shoe_tile.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/shoe.dart';
import 'package:comfi/pages/column_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  void addShoeToCart(Shoe shoe) {
    Provider.of<Cart>(context, listen: false).addItemToCart(shoe);

    // Check if widget is still mounted before showing dialog
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
                                      "Hi Mike,",
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
                                      "Find your home away from home!",
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
                                    child: Row(
                                      children: const [
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
                          // ================= HERO BANNER =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Container(
                              // Much taller on larger screens → gives space for more text
                              height: isDesktop
                                  ? 420
                                  : isTablet
                                  ? 360
                                  : 300, // mobile still comfortable but not overwhelming
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                // Optional: subtle border or shadow for depth
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
                                    // Background image – full space
                                    Image.asset(
                                      'lib/images/smart-shopping-tips.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),

                                    // Dark overlay – adjustable for readability
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

                                    // Content – more space, better typography hierarchy
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
                                            const SizedBox(height: 16),

                                            const SizedBox(height: 32),
                                            ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.explore,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                "Explore Hostels Now",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
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
                                                // Add navigation or scroll to featured section
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
                          const SizedBox(
                            height: 40,
                          ), // increased spacing after banner

                          const SizedBox(height: 15),

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
                                    itemCount: cart.getShoeList().length,
                                    itemBuilder: (context, index) {
                                      final shoe = cart.getShoeList()[index];
                                      return ShoeTile(
                                        shoe: shoe,
                                        onTap: () => addShoeToCart(shoe),
                                        isInGrid: true,
                                      );
                                    },
                                  )
                                : SizedBox(
                                    height: 260,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cart.getShoeList().length,
                                      itemBuilder: (context, index) {
                                        final shoe = cart.getShoeList()[index];
                                        return ShoeTile(
                                          shoe: shoe,
                                          onTap: () => addShoeToCart(shoe),
                                          isInGrid: false,
                                        );
                                      },
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 30),

                          // ================= FEATURED HOSTELS =================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: const Text(
                              "Featured Hostels 🏠",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: isTablet ? 2 : 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: const [
                                HostelCard(
                                  imagePath: 'lib/images/fada.jpeg',
                                  name: 'Green View Hostel',
                                ),
                                HostelCard(
                                  imagePath: 'lib/images/A1.jpg',
                                  name: 'Sunrise Hostel',
                                ),
                                HostelCard(
                                  imagePath: 'lib/images/hostel1.jpeg',
                                  name: 'Royal Comfort Hostel',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
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

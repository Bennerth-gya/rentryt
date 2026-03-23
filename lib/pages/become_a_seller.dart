import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/app_theme.dart';
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

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  int _currentBanner = 0;
  int _selectedCategory = 0;
  late AnimationController _headerAnim;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All',         'icon': Icons.grid_view_rounded},
    {'label': 'Electronics', 'icon': Icons.devices_rounded},
    {'label': 'Education',   'icon': Icons.menu_book_rounded},
    {'label': 'Men',         'icon': Icons.man_rounded},
    {'label': 'Ladies',      'icon': Icons.woman_rounded},
    {'label': 'Clothing',    'icon': Icons.checkroom_rounded},
    {'label': 'Shoes',       'icon': Icons.hiking_rounded},
    {'label': 'Accessories', 'icon': Icons.watch_rounded},
    {'label': 'Home',        'icon': Icons.home_rounded},
  ];

  final List<Map<String, String>> bannerItems = [
    {
      'image'   : 'assets/images/black_man.jpg',
      'title'   : 'New Collection',
      'subtitle': 'Up to 50% Off',
      'tag'     : 'HOT',
    },
    {
      'image'   : 'assets/images/beautiful_dark_shopping.jpg',
      'title'   : 'Summer Sale',
      'subtitle': 'Fresh Styles Await',
      'tag'     : 'SALE',
    },
    {
      'image'   : 'assets/images/dark_lady_shopping.jpg',
      'title'   : 'Limited Stock',
      'subtitle': 'Grab It Now',
      'tag'     : 'LIMITED',
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade = CurvedAnimation(
        parent: _headerAnim, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _headerAnim, curve: Curves.easeOut));
    _headerAnim.forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

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
    _showAddedSnackbar(product.name);
  }

  void _showAddedSnackbar(String name) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF8B5CF6), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$name added to cart',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: const Text('OK',
                  style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg         = isDark ? const Color(0xFF080C14)  : const Color(0xFFF5F7FF);
    final surfaceColor       = isDark ? const Color(0xFF111827)  : Colors.white;
    final borderColor        = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText        = isDark ? Colors.white             : const Color(0xFF0F172A);
    final secondaryText      = isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF64748B);
    final searchHint         = isDark ? Colors.white.withOpacity(0.35) : const Color(0xFFADB5C7);
    final chipSelected       = const Color(0xFF8B5CF6);
    final chipUnselected     = isDark ? const Color(0xFF111827)  : const Color(0xFFEEF1FB);
    final chipTextUnselected = isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF64748B);
    final dotInactive        = isDark ? Colors.white.withOpacity(0.2)  : const Color(0xFF8B5CF6).withOpacity(0.2);
    final iconColor          = isDark ? Colors.white.withOpacity(0.75) : const Color(0xFF475569);
    final filterIconColor    = isDark ? Colors.white.withOpacity(0.6)  : const Color(0xFF475569);

    return Consumer<Cart>(
      builder: (context, cart, _) {
        final selectedLabel =
            _categories[_selectedCategory]['label'] as String;
        final displayProducts =
            cart.getProductsForCategory(selectedLabel);

        return Scaffold(
          backgroundColor: scaffoldBg,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width     = constraints.maxWidth;
                final isTablet  = width >= 600;
                final isDesktop = width >= 1000;
                final hPad      = isDesktop ? 200.0 : isTablet ? 60.0 : 20.0;
                final bannerHeight =
                    isDesktop ? 420.0 : isTablet ? 360.0 : 230.0;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [

                    // ── HEADER ───────────────────────────────
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: SlideTransition(
                          position: _headerSlide,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                hPad, 20, hPad, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44, height: 44,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF7C3AED),
                                              Color(0xFFA78BFA),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text('S',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Good morning 👋',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: secondaryText,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text('Hi Systrom',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: primaryText,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _HeaderAction(
                                      icon: Icons.notifications_none_rounded,
                                      badge: true,
                                      onTap: () {},
                                      surfaceColor: surfaceColor,
                                      borderColor: borderColor,
                                      iconColor: iconColor,
                                      badgeBorderColor: scaffoldBg,
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const BecomeSellerScreen(),
                                        ),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 9),
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.primaryGradient,
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF8B5CF6)
                                                  .withOpacity(0.35),
                                              blurRadius: 14,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.storefront_rounded,
                                                size: 13,
                                                color: Colors.white),
                                            SizedBox(width: 5),
                                            Text('Sell',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── SEARCH BAR ───────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _openSearch,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search_rounded,
                                          color: searchHint, size: 20),
                                      const SizedBox(width: 10),
                                      Text('Search products...',
                                        style: TextStyle(
                                            color: searchHint,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor),
                              ),
                              child: Icon(Icons.tune_rounded,
                                  color: filterIconColor, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── BANNER CAROUSEL ──────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
                        child: Column(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: bannerHeight,
                                autoPlay: true,
                                autoPlayInterval:
                                    const Duration(seconds: 4),
                                autoPlayCurve: Curves.easeInOut,
                                enlargeCenterPage: true,
                                viewportFraction: isDesktop
                                    ? 0.7
                                    : isTablet ? 0.82 : 1.0,
                                onPageChanged: (i, _) => setState(
                                    () => _currentBanner = i),
                              ),
                              items: bannerItems
                                  .map((b) => _BannerCard(banner: b))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                bannerItems.length,
                                (i) => AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  width: i == _currentBanner ? 20 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: i == _currentBanner
                                        ? const Color(0xFF8B5CF6)
                                        : dotInactive,
                                    borderRadius:
                                        BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── CATEGORIES ───────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(hPad, 28, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: hPad),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Categories',
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B5CF6)
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${displayProducts.length} items',
                                      style: const TextStyle(
                                        color: Color(0xFF8B5CF6),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 42,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(right: hPad),
                                itemCount: _categories.length,
                                itemBuilder: (_, i) {
                                  final selected =
                                      i == _selectedCategory;
                                  final label = _categories[i]['label']
                                      as String;
                                  final icon = _categories[i]['icon']
                                      as IconData;
                                  return GestureDetector(
                                    onTap: () => setState(
                                        () => _selectedCategory = i),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 250),
                                      margin: const EdgeInsets.only(
                                          right: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? chipSelected
                                            : chipUnselected,
                                        borderRadius:
                                            BorderRadius.circular(21),
                                        border: Border.all(
                                          color: selected
                                              ? chipSelected
                                              : borderColor,
                                        ),
                                        boxShadow: selected
                                            ? [
                                                BoxShadow(
                                                  color: const Color(
                                                          0xFF8B5CF6)
                                                      .withOpacity(0.4),
                                                  blurRadius: 12,
                                                  offset: const Offset(
                                                      0, 4),
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(icon,
                                            size: 14,
                                            color: selected
                                                ? Colors.white
                                                : chipTextUnselected,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(label,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: selected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: selected
                                                  ? Colors.white
                                                  : chipTextUnselected,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── SECTION TITLE ────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(hPad, 28, hPad, 16),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Align(
                            key: ValueKey(selectedLabel),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedLabel == 'All'
                                  ? 'All Products'
                                  : 'Best in $selectedLabel',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── PRODUCT GRID or EMPTY ────────────────
                    displayProducts.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 72, height: 72,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B5CF6)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _categories[_selectedCategory]
                                          ['icon'] as IconData,
                                      color: const Color(0xFF8B5CF6)
                                          .withOpacity(0.5),
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text('No products yet',
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Check back soon for\nnew arrivals',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white.withOpacity(0.4)
                                          : const Color(0xFF94A3B8),
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding:
                                EdgeInsets.fromLTRB(hPad, 0, hPad, 80),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product =
                                      displayProducts[index];
                                  return ProductsTile(
                                    product: product,
                                    onAddToCart: () =>
                                        addProductToCart(product),
                                    isInGrid: true,
                                  );
                                },
                                childCount: displayProducts.length,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    isDesktop ? 4 : isTablet ? 3 : 2,
                                childAspectRatio: 0.50,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 14,
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ── Banner Card ───────────────────────────────────────────────────────────────
class _BannerCard extends StatelessWidget {
  final Map<String, String> banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(banner['image']!, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 18, bottom: 20, right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (banner['tag'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(banner['tag']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(banner['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(banner['subtitle']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16, bottom: 20,
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.25)),
              ),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header Action ─────────────────────────────────────────────────────────────
class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;
  final Color surfaceColor;
  final Color borderColor;
  final Color iconColor;
  final Color badgeBorderColor;

  const _HeaderAction({
    required this.icon,
    required this.onTap,
    required this.surfaceColor,
    required this.borderColor,
    required this.iconColor,
    required this.badgeBorderColor,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: borderColor),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          if (badge)
            Positioned(
              top: -2, right: -2,
              child: Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: badgeBorderColor, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
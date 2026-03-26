import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/app_theme.dart';
import 'package:comfi/consts/theme_toggle_button.dart' show ThemeToggleButton;
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/pages/product_search_delegate.dart';
import 'package:comfi/pages/seller_section/sellers_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class SellerShopPage extends StatefulWidget {
  const SellerShopPage({super.key});

  @override
  State<SellerShopPage> createState() => _SellerShopPageState();
}

class _SellerShopPageState extends State<SellerShopPage>
    with TickerProviderStateMixin {
  // ✅ Key declared at state level — used on the outermost ScaffoldMessenger
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  int _currentBanner = 0;
  int _selectedCategory = 0;
  late AnimationController _headerAnim;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Electronics', 'icon': Icons.devices_rounded},
    {'label': 'Education', 'icon': Icons.menu_book_rounded},
    {'label': 'Men', 'icon': Icons.man_rounded},
    {'label': 'Ladies', 'icon': Icons.woman_rounded},
    {'label': 'Clothing', 'icon': Icons.checkroom_rounded},
    {'label': 'Shoes', 'icon': Icons.hiking_rounded},
    {'label': 'Accessories', 'icon': Icons.watch_rounded},
    {'label': 'Home', 'icon': Icons.home_rounded},
  ];

  final List<Map<String, String>> bannerItems = [
    {
      'image': 'assets/images/black_man.jpg',
      'title': 'New Collection',
      'subtitle': 'Up to 50% Off',
      'tag': 'HOT',
    },
    {
      'image': 'assets/images/beautiful_dark_shopping.jpg',
      'title': 'Summer Sale',
      'subtitle': 'Fresh Styles Await',
      'tag': 'SALE',
    },
    {
      'image': 'assets/images/dark_lady_shopping.jpg',
      'title': 'Limited Stock',
      'subtitle': 'Grab It Now',
      'tag': 'LIMITED',
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade =
        CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut));
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

  void _showAddedSnackbar(String productName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messenger = _messengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF8B5CF6),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$productName added to cart',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _messengerKey.currentState?.hideCurrentSnackBar(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final isSmallPhone = screenH < 680;
    final isTablet = screenW >= 600;
    final isDesktop = screenW >= 1000;

    final hPad = isDesktop
        ? 200.0
        : isTablet
            ? 60.0
            : isSmallPhone
                ? 14.0
                : 20.0;
    final bannerHeight = isDesktop
        ? 420.0
        : isTablet
            ? 360.0
            : isSmallPhone
                ? 180.0
                : 230.0;
    final gridCols = isDesktop ? 4 : isTablet ? 3 : 2;
    final sectionFs = isTablet ? 20.0 : isSmallPhone ? 15.0 : 18.0;
    final avatarSize = isSmallPhone ? 36.0 : 42.0;
    final greetingFs = isSmallPhone ? 10.0 : 11.0;
    final nameFs = isSmallPhone ? 14.0 : 17.0;
    final chipH = isSmallPhone ? 36.0 : 42.0;
    final chipFs = isSmallPhone ? 11.0 : 13.0;
    final chipPadH = isSmallPhone ? 10.0 : 14.0;
    final chipIconSize = isSmallPhone ? 12.0 : 14.0;
    final searchFs = isSmallPhone ? 12.0 : 14.0;
    final headerVPad = isSmallPhone ? 12.0 : 20.0;
    final searchVPad = isSmallPhone ? 10.0 : 14.0;
    final sectionGap = isSmallPhone ? 16.0 : 28.0;
    final bottomPad = isSmallPhone ? 60.0 : 80.0;
    final btnSize = isSmallPhone ? 36.0 : 42.0;

    final scaffoldBg =
        isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);
    final searchHint = isDark
        ? Colors.white.withOpacity(0.35)
        : const Color(0xFFADB5C7);
    final chipSelected = const Color(0xFF8B5CF6);
    final chipUnselected =
        isDark ? const Color(0xFF111827) : const Color(0xFFEEF1FB);
    final chipTextUnselected = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);
    final dotInactive = isDark
        ? Colors.white.withOpacity(0.2)
        : const Color(0xFF8B5CF6).withOpacity(0.2);
    final iconColor = isDark
        ? Colors.white.withOpacity(0.75)
        : const Color(0xFF475569);
    final filterIconColor = isDark
        ? Colors.white.withOpacity(0.6)
        : const Color(0xFF475569);

    // ✅ ScaffoldMessenger is the OUTERMOST widget — wraps everything including
    //    Consumer and Scaffold, so snackbars always have a valid render target.
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Consumer<Cart>(
        builder: (context, cart, _) {
          final selectedLabel =
              _categories[_selectedCategory]['label'] as String;
          final displayProducts =
              cart.getProductsForCategory(selectedLabel);

          return Scaffold(
            backgroundColor: scaffoldBg,
            bottomNavigationBar: SellerMainScreen(),
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── HEADER ─────────────────────────────
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              hPad, headerVPad, hPad, 0),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: avatarSize,
                                      height: avatarSize,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF7C3AED),
                                            Color(0xFFA78BFA),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'S',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                isSmallPhone ? 14 : 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Good morning 👋',
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: greetingFs,
                                              color: secondaryText,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Hi Systrom',
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: nameFs,
                                              fontWeight: FontWeight.w700,
                                              color: primaryText,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _HeaderAction(
                                    icon: Icons
                                        .notifications_none_rounded,
                                    badge: true,
                                    onTap: () {},
                                    surfaceColor: surfaceColor,
                                    borderColor: borderColor,
                                    iconColor: iconColor,
                                    badgeBorderColor: scaffoldBg,
                                    size: btnSize,
                                  ),
                                  SizedBox(
                                      width: isSmallPhone ? 6 : 10),
                                  ThemeToggleButton(
                                    surfaceColor: surfaceColor,
                                    borderColor: borderColor,
                                    size: btnSize,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── SEARCH BAR ─────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad, isSmallPhone ? 12 : 20, hPad, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _openSearch,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: searchVPad,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  border:
                                      Border.all(color: borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search_rounded,
                                      color: searchHint,
                                      size: isSmallPhone ? 18 : 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Search products...',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: searchHint,
                                          fontSize: searchFs,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: isSmallPhone ? 42 : 50,
                            height: isSmallPhone ? 42 : 50,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: filterIconColor,
                              size: isSmallPhone ? 17 : 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── BANNER CAROUSEL ─────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad, isSmallPhone ? 14 : 24, hPad, 0),
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
                                  : isTablet
                                      ? 0.82
                                      : 1.0,
                              onPageChanged: (i, _) =>
                                  setState(() => _currentBanner = i),
                            ),
                            items: bannerItems
                                .map((b) => _BannerCard(
                                      banner: b,
                                      isSmallPhone: isSmallPhone,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              bannerItems.length,
                              (i) => AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 3),
                                width: i == _currentBanner ? 18 : 5,
                                height: 5,
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

                  // ── CATEGORIES ─────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad, sectionGap, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: hPad),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Categories',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: sectionFs,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                                    style: TextStyle(
                                      color: const Color(0xFF8B5CF6),
                                      fontSize: isSmallPhone ? 10 : 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isSmallPhone ? 10 : 14),
                          SizedBox(
                            height: chipH,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: hPad),
                              itemCount: _categories.length,
                              itemBuilder: (_, i) {
                                final selected =
                                    i == _selectedCategory;
                                final label =
                                    _categories[i]['label'] as String;
                                final icon =
                                    _categories[i]['icon'] as IconData;
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedCategory = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 250),
                                    margin: const EdgeInsets.only(
                                        right: 8),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: chipPadH),
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
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          icon,
                                          size: chipIconSize,
                                          color: selected
                                              ? Colors.white
                                              : chipTextUnselected,
                                        ),
                                        SizedBox(
                                            width: isSmallPhone
                                                ? 4
                                                : 6),
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: chipFs,
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

                  // ── SECTION TITLE ───────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad,
                          sectionGap,
                          hPad,
                          isSmallPhone ? 10 : 16),
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
                              fontSize: sectionFs,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── PRODUCT GRID or EMPTY ───────────────
                  displayProducts.isEmpty
                      ? SliverToBoxAdapter(
                          child: SizedBox(
                            height: isSmallPhone ? 260.0 : 320.0,
                            child: _EmptyState(
                              icon: _categories[_selectedCategory]
                                  ['icon'] as IconData,
                              primaryText: primaryText,
                              emptyColor: isDark
                                  ? Colors.white.withOpacity(0.4)
                                  : const Color(0xFF94A3B8),
                              isSmallPhone: isSmallPhone,
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                              hPad, 0, hPad, bottomPad),
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
                              crossAxisCount: gridCols,
                              mainAxisExtent: isDesktop
                                  ? 340.0
                                  : isTablet
                                      ? 320.0
                                      : isSmallPhone
                                          ? 265.0
                                          : 335.0,
                              crossAxisSpacing:
                                  isSmallPhone ? 8 : 10,
                              mainAxisSpacing:
                                  isSmallPhone ? 10 : 14,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Banner Card ───────────────────────────────────────────────────────────────
class _BannerCard extends StatelessWidget {
  final Map<String, String> banner;
  final bool isSmallPhone;

  const _BannerCard({required this.banner, this.isSmallPhone = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            banner['image']!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF1F2937),
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.white24,
                size: 40,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.35, 1.0],
              ),
            ),
          ),
          Positioned(
            left: isSmallPhone ? 12 : 18,
            bottom: isSmallPhone ? 12 : 20,
            right: isSmallPhone ? 52 : 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallPhone ? 6 : 8,
                    vertical: isSmallPhone ? 2 : 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    banner['tag']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallPhone ? 8 : 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: isSmallPhone ? 4 : 6),
                Text(
                  banner['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallPhone ? 15 : 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: isSmallPhone ? 2 : 3),
                Text(
                  banner['subtitle']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: isSmallPhone ? 11 : 13,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: isSmallPhone ? 10 : 16,
            bottom: isSmallPhone ? 12 : 20,
            child: Container(
              width: isSmallPhone ? 30 : 38,
              height: isSmallPhone ? 30 : 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: isSmallPhone ? 14 : 18,
              ),
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
  final double size;

  const _HeaderAction({
    required this.icon,
    required this.onTap,
    required this.surfaceColor,
    required this.borderColor,
    required this.iconColor,
    required this.badgeBorderColor,
    this.badge = false,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final iconSz = size < 40 ? 17.0 : 20.0;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(size * 0.3),
              border: Border.all(color: borderColor),
            ),
            child: Icon(icon, color: iconColor, size: iconSz),
          ),
          if (badge)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: badgeBorderColor, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final Color primaryText;
  final Color emptyColor;
  final bool isSmallPhone;

  const _EmptyState({
    required this.icon,
    required this.primaryText,
    required this.emptyColor,
    required this.isSmallPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isSmallPhone ? 56 : 72,
              height: isSmallPhone ? 56 : 72,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8B5CF6).withOpacity(0.5),
                size: isSmallPhone ? 24 : 32,
              ),
            ),
            SizedBox(height: isSmallPhone ? 12 : 16),
            Text(
              'No products yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText,
                fontSize: isSmallPhone ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isSmallPhone ? 4 : 6),
            Text(
              'Check back soon for\nnew arrivals',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: emptyColor,
                fontSize: isSmallPhone ? 12 : 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
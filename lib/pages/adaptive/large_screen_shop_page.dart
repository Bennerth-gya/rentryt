import 'package:carousel_slider/carousel_slider.dart';
import 'package:comfi/components/product_card.dart';
import 'package:comfi/components/section_container.dart';
import 'package:comfi/consts/theme_toggle_button.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/pages/product_search_delegate.dart';
import 'package:comfi/presentation/widgets/app_error_state.dart';
import 'package:comfi/presentation/widgets/app_loading_state.dart';
import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:comfi/widgets/responsive/responsive_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LargeScreenShopPage extends StatefulWidget {
  const LargeScreenShopPage({super.key});

  @override
  State<LargeScreenShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<LargeScreenShopPage> {
  int _selectedCategory = 0;
  int _currentBanner = 0;

  static const List<_ShopCategory> _categories = <_ShopCategory>[
    _ShopCategory(label: 'All', icon: Icons.grid_view_rounded),
    _ShopCategory(label: 'Electronics', icon: Icons.devices_rounded),
    _ShopCategory(label: 'Education', icon: Icons.menu_book_rounded),
    _ShopCategory(label: 'Men', icon: Icons.man_rounded),
    _ShopCategory(label: 'Ladies', icon: Icons.woman_rounded),
    _ShopCategory(label: 'Clothing', icon: Icons.checkroom_rounded),
    _ShopCategory(label: 'Shoes', icon: Icons.hiking_rounded),
    _ShopCategory(label: 'Accessories', icon: Icons.watch_rounded),
    _ShopCategory(label: 'Home', icon: Icons.home_rounded),
  ];

  static const List<_ShopBanner> _banners = <_ShopBanner>[
    _ShopBanner(
      image: 'assets/images/beautiful_dark_shopping.jpg',
      tag: 'Fresh Drop',
      title: 'Desktop-ready shopping, same Comfi feel',
      subtitle: 'Discover curated deals with a cleaner layout and faster browsing.',
    ),
    _ShopBanner(
      image: 'assets/images/black_man.jpg',
      tag: 'Today',
      title: 'Build a basket from verified sellers',
      subtitle: 'Track price, seller quality, and shipping options in one flow.',
    ),
    _ShopBanner(
      image: 'assets/images/dark_lady_shopping.jpg',
      tag: 'Limited',
      title: 'Negotiated offers without the clutter',
      subtitle: 'Jump from discovery to chat to checkout without losing context.',
    ),
  ];

  void _openSearch() {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(
        cart: Provider.of<Cart>(context, listen: false),
      ),
    );
  }

  void _addProductToCart(Products product) {
    Provider.of<Cart>(context, listen: false).addItemToCart(product);
    if (!mounted) {
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        content: Text(
          '${product.name} added to cart',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Consumer<Cart>(
          builder: (context, cart, _) {
            if (cart.isBootstrapping && cart.allProducts.isEmpty) {
              return const AppLoadingState(label: 'Loading products...');
            }

            if (cart.errorMessage != null && cart.allProducts.isEmpty) {
              return AppErrorState(
                message: cart.errorMessage!,
                onRetry: cart.bootstrap,
              );
            }

            final selectedLabel = _categories[_selectedCategory].label;
            final products = cart.getProductsForCategory(selectedLabel);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ResponsiveWrapper(
                maxWidth: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShopHeader(onOpenSearch: _openSearch),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, _) {
                        if (Responsive.isDesktop(context)) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _ShopHero(
                                  banners: _banners,
                                  currentBanner: _currentBanner,
                                  onPageChanged: (index) {
                                    setState(() => _currentBanner = index);
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  children: const [
                                    _InsightCard(
                                      title: 'Fast checkout',
                                      value: '2 mins',
                                      subtitle: 'Average time from negotiated deal to payment.',
                                      accent: Color(0xFF8B5CF6),
                                      icon: Icons.flash_on_rounded,
                                    ),
                                    SizedBox(height: 16),
                                    _InsightCard(
                                      title: 'Trusted sellers',
                                      value: '98%',
                                      subtitle: 'Orders placed with verified merchants this week.',
                                      accent: Color(0xFF10B981),
                                      icon: Icons.verified_user_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            _ShopHero(
                              banners: _banners,
                              currentBanner: _currentBanner,
                              onPageChanged: (index) {
                                setState(() => _currentBanner = index);
                              },
                            ),
                            const SizedBox(height: 16),
                            const _InsightStrip(),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _CategoriesBar(
                      categories: _categories,
                      selectedIndex: _selectedCategory,
                      onSelected: (index) => setState(() => _selectedCategory = index),
                      resultCount: products.length,
                    ),
                    const SizedBox(height: 24),
                    _ProductsHeader(
                      title: selectedLabel == 'All'
                          ? 'Recommended for you'
                          : 'Best in $selectedLabel',
                      count: products.length,
                    ),
                    const SizedBox(height: 18),
                    if (products.isEmpty)
                      const _EmptyProductsState()
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.productGridCount(context),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 18,
                          mainAxisExtent: Responsive.value(
                            context,
                            mobile: 300,
                            tablet: 320,
                            desktop: 332,
                          ),
                        ),
                        itemBuilder: (context, index) => ProductCard(
                          product: products[index],
                          onAddToCart: () => _addProductToCart(products[index]),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.onOpenSearch});

  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, Systrom',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: Responsive.value(
                        context,
                        mobile: 26,
                        tablet: 30,
                        desktop: 34,
                      ),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.9,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse better on every screen with cleaner spacing, quicker filters, and a stronger buying flow.',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) ...[
              const SizedBox(width: 16),
              ThemeToggleButton(
                surfaceColor: panelColor,
                borderColor: borderColor,
                size: 44,
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.becomeSeller),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.storefront_rounded),
                label: const Text(
                  'Sell on Comfi',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        SectionContainer(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onOpenSearch,
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 10),
                        Text(
                          'Search products, brands, and sellers',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (Responsive.isMobile(context)) ...[
                const SizedBox(width: 12),
                ThemeToggleButton(
                  surfaceColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderColor: borderColor,
                  size: 50,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ShopHero extends StatelessWidget {
  const _ShopHero({
    required this.banners,
    required this.currentBanner,
    required this.onPageChanged,
  });

  final List<_ShopBanner> banners;
  final int currentBanner;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final heroHeight = Responsive.value(
      context,
      mobile: 260,
      tablet: 320,
      desktop: 360,
    );

    return SectionContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: heroHeight.toDouble(),
              autoPlay: true,
              viewportFraction: 1,
              onPageChanged: (index, _) => onPageChanged(index),
            ),
            items: banners
                .map(
                  (banner) => _ShopBannerCard(
                    banner: banner,
                    height: heroHeight.toDouble(),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentBanner == index ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentBanner == index
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFFD8B4FE),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _ShopBannerCard extends StatelessWidget {
  const _ShopBannerCard({
    required this.banner,
    required this.height,
  });

  final _ShopBanner banner;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            banner.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1F2937)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    banner.tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  banner.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.value(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 34,
                    ),
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightStrip extends StatelessWidget {
  const _InsightStrip();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _InsightCard(
            title: 'Deals saved',
            value: 'GHS 125',
            subtitle: 'Savings secured from recent negotiated orders.',
            accent: Color(0xFF8B5CF6),
            icon: Icons.sell_rounded,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _InsightCard(
            title: 'Repeat sellers',
            value: '14',
            subtitle: 'Merchants you can jump back to with confidence.',
            accent: Color(0xFF10B981),
            icon: Icons.people_alt_rounded,
          ),
        ),
      ],
    );
  }
}

class _CategoriesBar extends StatelessWidget {
  const _CategoriesBar({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    required this.resultCount,
  });

  final List<_ShopCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Explore by category',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              Text(
                '$resultCount items',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List<Widget>.generate(
              categories.length,
              (index) {
                final category = categories[index];
                final isSelected = index == selectedIndex;

                return InkWell(
                  onTap: () => onSelected(index),
                  borderRadius: BorderRadius.circular(999),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8B5CF6)
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 16,
                          color: isSelected ? Colors.white : secondaryText,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : secondaryText,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
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
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count products',
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34),
        child: Column(
          children: const [
            Icon(
              Icons.inventory_2_outlined,
              size: 52,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 16),
            Text(
              'No products in this category yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'New arrivals will show up here as soon as sellers publish them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopCategory {
  const _ShopCategory({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class _ShopBanner {
  const _ShopBanner({
    required this.image,
    required this.tag,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String tag;
  final String title;
  final String subtitle;
}

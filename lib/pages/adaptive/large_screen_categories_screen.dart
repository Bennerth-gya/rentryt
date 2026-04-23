import 'package:comfi/components/product_card.dart';
import 'package:comfi/components/section_container.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/presentation/widgets/app_error_state.dart';
import 'package:comfi/presentation/widgets/app_loading_state.dart';
import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:comfi/widgets/responsive/responsive_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LargeScreenCategoriesScreen extends StatefulWidget {
  const LargeScreenCategoriesScreen({super.key});

  @override
  State<LargeScreenCategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<LargeScreenCategoriesScreen> {
  int _selectedCategoryIndex = 0;

  static const List<_CategoryOption> _categories = <_CategoryOption>[
    _CategoryOption(label: 'All', icon: Icons.grid_view_rounded),
    _CategoryOption(label: 'Electronics', icon: Icons.devices_rounded),
    _CategoryOption(label: 'Education', icon: Icons.menu_book_rounded),
    _CategoryOption(label: 'Men', icon: Icons.man_rounded),
    _CategoryOption(label: 'Ladies', icon: Icons.woman_rounded),
    _CategoryOption(label: 'Clothing', icon: Icons.checkroom_rounded),
    _CategoryOption(label: 'Shoes', icon: Icons.hiking_rounded),
    _CategoryOption(label: 'Accessories', icon: Icons.watch_rounded),
    _CategoryOption(label: 'Home', icon: Icons.home_rounded),
  ];

  void _addToCart(Products product) {
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
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Consumer<Cart>(
          builder: (context, cart, _) {
            if (cart.isBootstrapping && cart.allProducts.isEmpty) {
              return const AppLoadingState(label: 'Loading categories...');
            }

            if (cart.errorMessage != null && cart.allProducts.isEmpty) {
              return AppErrorState(
                message: cart.errorMessage!,
                onRetry: cart.bootstrap,
              );
            }

            final selectedLabel = _categories[_selectedCategoryIndex].label;
            final products = cart.getProductsForCategory(selectedLabel);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ResponsiveWrapper(
                maxWidth: 1200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse the full catalog with denser tablet grids and a wider desktop collection view.',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SectionContainer(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List<Widget>.generate(
                          _categories.length,
                          (index) {
                            final category = _categories[index];
                            final isSelected = index == _selectedCategoryIndex;

                            return InkWell(
                              onTap: () => setState(() => _selectedCategoryIndex = index),
                              borderRadius: BorderRadius.circular(999),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF8B5CF6)
                                      : (isDark
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFFF8FAFC)),
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
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedLabel == 'All'
                                ? 'Explore the full collection'
                                : '$selectedLabel picks',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${products.length} items',
                            style: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    if (products.isEmpty)
                      const _CategoryEmptyState()
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
                          onAddToCart: () => _addToCart(products[index]),
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

class _CategoryEmptyState extends StatelessWidget {
  const _CategoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34),
        child: Column(
          children: const [
            Icon(
              Icons.category_outlined,
              size: 52,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(height: 16),
            Text(
              'Nothing in this category yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Products from this section will appear here once sellers publish them.',
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

class _CategoryOption {
  const _CategoryOption({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

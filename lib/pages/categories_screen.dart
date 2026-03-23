import 'package:flutter/material.dart';
import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/app_theme.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:provider/provider.dart';

import '../consts/theme_toggle_button.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

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

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
        parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _selectCategory(int index) {
    if (index == _selectedCategoryIndex) return;
    _fadeController.reset();
    setState(() => _selectedCategoryIndex = index);
    _fadeController.forward();
  }

  String get _sectionTitle {
    final label =
        _categories[_selectedCategoryIndex]['label'] as String;
    return label == 'All' ? 'Explore Our Collection' : 'Best in $label';
  }

  void _addToCart(BuildContext context, Products product) {
    Provider.of<Cart>(context, listen: false).addItemToCart(product);
    if (!mounted) return;
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
                '${product.name} added to cart',
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar(),
              child: const Text('OK',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.w600,
                  )),
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
    final chipSelected       = const Color(0xFF8B5CF6);
    final chipUnselected     = isDark ? const Color(0xFF111827)  : const Color(0xFFEEF1FB);
    final chipTextUnselected = isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF64748B);
    final emptyTextColor     = isDark ? Colors.white.withOpacity(0.4)  : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: scaffoldBg,

      // ── App Bar ─────────────────────────────────────────
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // title: Text(
        //   'Categories',
        //   style: TextStyle(
        //     color: primaryText,
        //     fontSize: 20,
        //     fontWeight: FontWeight.w700,
        //     letterSpacing: -0.3,
        //   ),
        // ),
        actions: [
          // // ✅ Theme toggle button
          // ThemeToggleButton(
          //   surfaceColor: surfaceColor,
          //   borderColor: borderColor,
          //   size: 38,
          // ),
          const SizedBox(width: 8),

          // Item count badge
          Consumer<Cart>(
            builder: (context, cart, _) {
              final label = _categories[_selectedCategoryIndex]
                  ['label'] as String;
              final count = label == 'All'
                  ? cart.getFeaturedList().length
                  : cart.getProductsForCategory(label).length;
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF8B5CF6).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count items',
                  style: const TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Consumer<Cart>(
          builder: (context, cart, _) {
            final selectedLabel = _categories[_selectedCategoryIndex]
                ['label'] as String;
            final products = selectedLabel == 'All'
                ? cart.getFeaturedList()
                : cart.getProductsForCategory(selectedLabel);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                // ── Category chips ──────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.only(right: 16),
                        itemCount: _categories.length,
                        itemBuilder: (_, i) {
                          final selected =
                              i == _selectedCategoryIndex;
                          final label = _categories[i]['label']
                              as String;
                          final icon = _categories[i]['icon']
                              as IconData;

                          return GestureDetector(
                            onTap: () => _selectCategory(i),
                            child: AnimatedContainer(
                              duration: const Duration(
                                  milliseconds: 250),
                              margin: const EdgeInsets.only(
                                  right: 8),
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 14),
                              decoration: BoxDecoration(
                                color: selected
                                    ? chipSelected
                                    : chipUnselected,
                                borderRadius:
                                    BorderRadius.circular(22),
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
                                          offset:
                                              const Offset(0, 4),
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
                  ),
                ),

                // ── Section title ───────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Align(
                        key: ValueKey(_sectionTitle),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _sectionTitle,
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

                // ── Empty state ─────────────────────────────
                if (products.isEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 320,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _categories[_selectedCategoryIndex]
                                    ['icon'] as IconData,
                                color: const Color(0xFF8B5CF6)
                                    .withOpacity(0.5),
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text('Nothing here yet',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Products in this category\nwill appear here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: emptyTextColor,
                                fontSize: 13,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                // ── Product grid ────────────────────────────
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 0, 16, 80),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return FadeTransition(
                            opacity: _fadeAnim,
                            child: ProductsTile(
                              product: product,
                              onAddToCart: () =>
                                  _addToCart(context, product),
                              isInGrid: true,
                              showAddButton: true,
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 335,
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
  }
}
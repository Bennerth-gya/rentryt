import 'package:flutter/material.dart';
import 'package:comfi/components/products_tile.dart';
import 'package:comfi/consts/app_theme.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:provider/provider.dart';
import '../consts/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
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
    final label = _categories[_selectedCategoryIndex]['label'] as String;
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
        backgroundColor: isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF8B5CF6), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${product.name} added to cart',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
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

    // Best colors using your palette
    final scaffoldBg = isDark ? kDarkBg : kLightBg;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);

    final chipSelected = kViolet;
    final chipUnselected = isDark ? kDarkChip : kLightChip;
    final chipTextUnselected = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    final emptyTextColor = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF94A3B8);

    // Best borderColor
    final borderColor = isDark
        ? kDarkSurface.withOpacity(0.65)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<Cart>(
            builder: (context, cart, _) {
              final label = _categories[_selectedCategoryIndex]['label'] as String;
              final count = cart.getProductsForCategory(label).length;

              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kViolet.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count items',
                  style: const TextStyle(
                    color: kViolet,
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
            final selectedLabel = _categories[_selectedCategoryIndex]['label'] as String;
            final products = cart.getProductsForCategory(selectedLabel);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Category Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(right: 16),
                        itemCount: _categories.length,
                        itemBuilder: (_, i) {
                          final selected = i == _selectedCategoryIndex;
                          final label = _categories[i]['label'] as String;
                          final icon = _categories[i]['icon'] as IconData;

                          return GestureDetector(
                            onTap: () => _selectCategory(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: selected ? chipSelected : chipUnselected,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: selected ? chipSelected : borderColor,
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: kViolet.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    size: 15,
                                    color: selected ? Colors.white : chipTextUnselected,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                      color: selected ? Colors.white : chipTextUnselected,
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

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _sectionTitle,
                        key: ValueKey(_sectionTitle),
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ),

                // Products Grid or Empty State
                if (products.isEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 320,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: kViolet.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _categories[_selectedCategoryIndex]['icon'] as IconData,
                                color: kViolet.withOpacity(0.5),
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Nothing here yet',
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
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return FadeTransition(
                            opacity: _fadeAnim,
                            child: ProductsTile(
                              product: product,
                              onAddToCart: () => _addToCart(context, product),
                              isInGrid: true,
                              showAddButton: true,
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 335,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
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
import 'package:flutter/material.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/components/products_tile.dart';
import 'package:provider/provider.dart';

class ProductSearchDelegate extends SearchDelegate<Products?> {
  final Cart cart;
  ProductSearchDelegate({required this.cart});

  @override
  String get searchFieldLabel => 'Search products...';

  // ── App bar theme ───────────────────────────────────────────────────────────
  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme  = Theme.of(context);

    final bgColor     = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final primaryText  = isDark ? Colors.white : const Color(0xFF0F172A);
    final hintColor    = isDark
        ? Colors.white.withOpacity(0.35)
        : const Color(0xFFADB5C7);
    final borderColor  = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);

    return theme.copyWith(
      scaffoldBackgroundColor: bgColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryText),
        actionsIconTheme: IconThemeData(color: primaryText),
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        toolbarTextStyle: TextStyle(color: primaryText),
        shape: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      textTheme: theme.textTheme.apply(
        bodyColor: primaryText,
        displayColor: primaryText,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF8B5CF6),
        selectionColor: Color(0xFF8B5CF6),
        selectionHandleColor: Color(0xFF8B5CF6),
      ),
    );
  }

  // ── Actions ─────────────────────────────────────────────────────────────────
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  color: Color(0xFF8B5CF6), size: 16),
            ),
            onPressed: () {
              query = '';
              showSuggestions(context);
            },
          ),
        ),
    ];
  }

  // ── Leading ─────────────────────────────────────────────────────────────────
  @override
  Widget? buildLeading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded,
          color: primaryText, size: 18),
      onPressed: () => close(context, null),
    );
  }

  // ── Results & suggestions ────────────────────────────────────────────────────
  @override
  Widget buildResults(BuildContext context) =>
      _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) =>
      _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor       = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    // ── Empty query state ──────────────────────────────────
    if (query.trim().isEmpty) {
      return Container(
        color: bgColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search_rounded,
                    color: const Color(0xFF8B5CF6).withOpacity(0.6),
                    size: 32),
              ),
              const SizedBox(height: 16),
              Text('Search for anything',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try searching by product name,\ncategory, or description',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),

              // ── Quick suggestion chips ─────────────────
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: ['Electronics', 'Men', 'Ladies', 'Education', 'Home']
                    .map((tag) => GestureDetector(
                          onTap: () {
                            query = tag;
                            showResults(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.tag_rounded,
                                    size: 12,
                                    color: const Color(0xFF8B5CF6)),
                                const SizedBox(width: 5),
                                Text(tag,
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    final results = cart.searchProducts(query);

    // ── No results state ───────────────────────────────────
    if (results.isEmpty) {
      return Container(
        color: bgColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search_off_rounded,
                    color: const Color(0xFF8B5CF6).withOpacity(0.5),
                    size: 32),
              ),
              const SizedBox(height: 16),
              Text('No results found',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(text: 'No products matched '),
                    TextSpan(
                      text: '"$query"',
                      style: const TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Try a different keyword',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Results ────────────────────────────────────────────
    return Container(
      color: bgColor,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // Results count header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    '${results.length} result${results.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'for "$query"',
                    style: TextStyle(
                      color: const Color(0xFF8B5CF6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = results[index];
                  return ProductsTile(
                    product: product,
                    onAddToCart: () {
                      Provider.of<Cart>(context, listen: false)
                          .addItemToCart(product);
                      _showAddedSnackbar(context, product.name, isDark);
                    },
                    isInGrid: true,
                  );
                },
                childCount: results.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.50,
                crossAxisSpacing: 10,
                mainAxisSpacing: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddedSnackbar(
      BuildContext context, String name, bool isDark) {
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
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
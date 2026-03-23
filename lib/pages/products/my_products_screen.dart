import 'package:comfi/components/products_tile.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../consts/theme_toggle_button.dart';
import '../seller_post_product_screen.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
        parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _confirmDelete(
      BuildContext context, Cart cart, Products product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE2E8F0);

    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Warning icon
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFEF4444).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 28),
            ),

            const SizedBox(height: 16),

            Text('Delete product?',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '"${product.name}" will be permanently removed\nfrom your store.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Cancel',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cart.deleteProduct(product);
                      Navigator.pop(context);
                      _showDeletedSnackbar(
                          context, product.name);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFEF4444),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDeletedSnackbar(
      BuildContext context, String name) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
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
                color: const Color(0xFFEF4444)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('$name removed',
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 14,
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg     = isDark ? const Color(0xFF080C14)  : const Color(0xFFF5F7FF);
    final surfaceColor   = isDark ? const Color(0xFF111827)  : Colors.white;
    final borderColor    = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText    = isDark ? Colors.white             : const Color(0xFF0F172A);
    final emptyTextColor = isDark ? Colors.white.withOpacity(0.4) : const Color(0xFF94A3B8);

    return Consumer<Cart>(
      builder: (context, cart, _) {
        final myProducts = cart.sellerProducts;

        return Scaffold(
          backgroundColor: scaffoldBg,

          // ── APP BAR ──────────────────────────────────
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: surfaceColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            shape: Border(
                bottom: BorderSide(color: borderColor)),
            title: Row(
              children: [
                Text('My Products',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 10),
                if (myProducts.isNotEmpty)
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
                      '${myProducts.length}',
                      style: const TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [

              // ✅ Theme toggle
              ThemeToggleButton(
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                size: 38,
              ),
              const SizedBox(width: 8),

              // Add product button
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SellerPostProductScreen(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7C3AED),
                          Color(0xFF8B5CF6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── BODY ─────────────────────────────────────
          body: myProducts.isEmpty
              ? _EmptyState(
                  isDark: isDark,
                  primaryText: primaryText,
                  emptyTextColor: emptyTextColor,
                  onAddProduct: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SellerPostProductScreen(),
                    ),
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [

                        // Stats row
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(
                                    16, 16, 16, 0),
                            child: Row(
                              children: [
                                _StatChip(
                                  icon: Icons
                                      .inventory_2_rounded,
                                  label:
                                      '${myProducts.length} product${myProducts.length == 1 ? '' : 's'}',
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                _StatChip(
                                  icon: Icons
                                      .storefront_rounded,
                                  label: 'Live in store',
                                  isDark: isDark,
                                  isActive: true,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Grid
                        SliverPadding(
                          padding:
                              const EdgeInsets.fromLTRB(
                                  16, 16, 16, 100),
                          sliver: SliverGrid(
                            delegate:
                                SliverChildBuilderDelegate(
                              (context, index) {
                                final product =
                                    myProducts[index];
                                return _ProductCard(
                                  product: product,
                                  isDark: isDark,
                                  surfaceColor: surfaceColor,
                                  borderColor: borderColor,
                                  onEdit: () =>
                                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SellerPostProductScreen(
                                        productToEdit:
                                            product,
                                      ),
                                    ),
                                  ),
                                  onDelete: () =>
                                      _confirmDelete(
                                          context,
                                          cart,
                                          product),
                                );
                              },
                              childCount: myProducts.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.56,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

// ── Product card with actions ─────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final Products product;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProductsTile(
          product: product,
          onAddToCart: () {},
          isInGrid: true,
        ),
        Positioned(
          top: 8, right: 8,
          child: Column(
            children: [
              _ActionBtn(
                icon: Icons.edit_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: onEdit,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
                onTap: onDelete,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Circular action button ────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1F2937)
              : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 15),
      ),
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool isActive;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.isDark,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isActive
        ? const Color(0xFF34D399).withOpacity(0.1)
        : isDark
            ? const Color(0xFF111827)
            : const Color(0xFFEEF1FB);
    final iconColor = isActive
        ? const Color(0xFF34D399)
        : const Color(0xFF8B5CF6);
    final textColor = isActive
        ? const Color(0xFF34D399)
        : isDark
            ? Colors.white.withOpacity(0.6)
            : const Color(0xFF64748B);
    final border = isActive
        ? const Color(0xFF34D399).withOpacity(0.25)
        : isDark
            ? Colors.white.withOpacity(0.06)
            : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 6),
          Text(label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isDark;
  final Color primaryText;
  final Color emptyTextColor;
  final VoidCallback onAddProduct;

  const _EmptyState({
    required this.isDark,
    required this.primaryText,
    required this.emptyTextColor,
    required this.onAddProduct,
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
              width: 88, height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6)
                    .withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF8B5CF6)
                      .withOpacity(0.18),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: const Color(0xFF8B5CF6)
                    .withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 22),

            Text('No products yet',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Start adding products to\nyour store and reach customers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: emptyTextColor,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            GestureDetector(
              onTap: onAddProduct,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF8B5CF6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6)
                          .withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Add First Product',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
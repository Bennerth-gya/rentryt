import 'package:comfi/components/products_details.dart';
// import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:comfi/models/cart.dart';

class ProductsTile extends StatefulWidget {
  final Products product;
  final VoidCallback? onAddToCart;
  final bool isInGrid;
  final bool showAddButton;

  const ProductsTile({
    super.key,
    required this.product,
    this.onAddToCart,
    this.isInGrid = true,
    this.showAddButton = true,
  });

  @override
  State<ProductsTile> createState() => _ProductsTileState();
}

class _ProductsTileState extends State<ProductsTile>
    with SingleTickerProviderStateMixin {
  bool _isFavourited = false;
  bool _isAdding     = false;

  late AnimationController _bounceCtrl;
  late Animation<double>   _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
    _bounceAnim = CurvedAnimation(
        parent: _bounceCtrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart() async {
    if (_isAdding) return;
    HapticFeedback.lightImpact();
    await _bounceCtrl.reverse();
    await _bounceCtrl.forward();
    setState(() => _isAdding = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isAdding = false);
    if (widget.onAddToCart != null) {
      widget.onAddToCart!();
    } else {
      Provider.of<Cart>(context, listen: false)
          .addItemToCart(widget.product);
      _showSnackbar(context);
    }
  }

  void _showSnackbar(BuildContext context) {
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
                '${widget.product.name} added to cart',
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 13,
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
    final product = widget.product;

    final cardBg        = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor   = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);
    final priceBg       = isDark
        ? const Color(0xFF8B5CF6).withOpacity(0.15)
        : const Color(0xFF8B5CF6).withOpacity(0.1);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsPage(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // ✅ Column with no Expanded children — safe inside
        //    SliverGrid with mainAxisExtent
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── IMAGE ────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(19)),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: isDark
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFEEF1FB),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: isDark
                              ? Colors.white.withOpacity(0.2)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  ),
                ),

                // Favourite button
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(
                          () => _isFavourited = !_isFavourited);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: _isFavourited
                            ? const Color(0xFFE83A8A)
                            : (isDark
                                ? Colors.black.withOpacity(0.45)
                                : Colors.white.withOpacity(0.9)),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavourited
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavourited
                            ? Colors.white
                            : (isDark
                                ? Colors.white.withOpacity(0.7)
                                : const Color(0xFF94A3B8)),
                        size: 15,
                      ),
                    ),
                  ),
                ),

                // Category badge
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withOpacity(0.55)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(product.category,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.75)
                            : const Color(0xFF475569),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── INFO ─────────────────────────────────
            // ✅ No Expanded here — plain Padding with
            //    mainAxisSize.min Column inside
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,   // ✅ key fix
                children: [

                  // Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Description — ✅ NO Expanded wrapper
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price + add button row
                  Row(
                    children: [
                      // Price badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priceBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'GHS ${product.price.toStringAsFixed(0)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Add to cart button
                      if (widget.showAddButton)
                        ScaleTransition(
                          scale: _bounceAnim,
                          child: GestureDetector(
                            onTap: _handleAddToCart,
                            child: AnimatedContainer(
                              duration: const Duration(
                                  milliseconds: 250),
                              width: 34, height: 34,
                              decoration: BoxDecoration(
                                color: _isAdding
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFF8B5CF6),
                                borderRadius:
                                    BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isAdding
                                            ? const Color(0xFF34D399)
                                            : const Color(0xFF8B5CF6))
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                    milliseconds: 250),
                                child: _isAdding
                                    ? const Icon(
                                        Icons.check_rounded,
                                        key: ValueKey('check'),
                                        color: Colors.white,
                                        size: 17,
                                      )
                                    : const Icon(
                                        Icons.add_rounded,
                                        key: ValueKey('add'),
                                        color: Colors.white,
                                        size: 19,
                                      ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
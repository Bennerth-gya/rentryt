import 'package:comfi/models/products.dart';
import 'package:comfi/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Products product;
  final int quantity;

  const CartItem({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _removeCtrl;
  late Animation<double> _removeAnim;

  @override
  void initState() {
    super.initState();
    _removeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _removeAnim = _removeCtrl;
  }

  @override
  void dispose() {
    _removeCtrl.dispose();
    super.dispose();
  }

  void _remove() {
    HapticFeedback.mediumImpact();
    Provider.of<Cart>(context, listen: false)
        .removeItemFromCart(widget.product);
  }

  void _decrease() {
    HapticFeedback.selectionClick();
    Provider.of<Cart>(context, listen: false)
        .decreaseQuantity(widget.product);
  }

  void _increase() {
    HapticFeedback.selectionClick();
    Provider.of<Cart>(context, listen: false)
        .increaseQuantity(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // ── Theme tokens ──────────────────────────────────
    final cardBg      = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);
    final qtyBg       = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFEEF1FB);
    final qtyBorder   = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE2E8F0);

    final totalPrice =
        widget.product.price * widget.quantity;

    return ScaleTransition(
      scale: _removeAnim,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [

              // ── Product image ──────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  widget.product.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFEEF1FB),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFFCBD5E1),
                      size: 28,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Info + controls ────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // Name + delete
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _remove,
                          child: Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444)
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(
                                        0xFFEF4444)
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6)
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.product.category,
                        style: const TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Price + quantity row
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        // Total price
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Total',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'GHS ${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),

                        // Quantity controls
                        Container(
                          decoration: BoxDecoration(
                            color: qtyBg,
                            borderRadius:
                                BorderRadius.circular(12),
                            border: Border.all(
                                color: qtyBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              // Decrease
                              GestureDetector(
                                onTap: _decrease,
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: widget.quantity == 1
                                        ? const Color(
                                                0xFFEF4444)
                                            .withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                  ),
                                  child: Icon(
                                    widget.quantity == 1
                                        ? Icons
                                            .delete_outline_rounded
                                        : Icons
                                            .remove_rounded,
                                    size: 15,
                                    color: widget.quantity == 1
                                        ? const Color(
                                            0xFFEF4444)
                                        : isDark
                                            ? Colors.white
                                                .withOpacity(
                                                    0.6)
                                            : const Color(
                                                0xFF64748B),
                                  ),
                                ),
                              ),

                              // Count
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8),
                                child: Text(
                                  '${widget.quantity}',
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),

                              // Increase
                              GestureDetector(
                                onTap: _increase,
                                child: Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                            0xFF8B5CF6)
                                        .withOpacity(0.12),
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    size: 15,
                                    color:
                                        Color(0xFF8B5CF6),
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
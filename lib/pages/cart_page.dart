
import 'package:comfi/pages/shop_page.dart';
import 'package:comfi/payment/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:comfi/components/cart_item.dart';
import 'package:comfi/models/cart.dart';
import 'package:provider/provider.dart';

import '../consts/theme_toggle_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg    = isDark ? const Color(0xFF080C14)  : const Color(0xFFF5F7FF);
    final appBarBg      = isDark ? const Color(0xFF080C14)  : const Color(0xFFF5F7FF);
    final appBarGradTop = isDark ? const Color(0xFF0F1526)  : const Color(0xFFEEF1FB);
    final primaryText   = isDark ? Colors.white             : const Color(0xFF0F172A);
    final surfaceColor  = isDark ? const Color(0xFF111827)  : Colors.white;
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Consumer<Cart>(
        builder: (context, value, child) {
          final isEmpty = value.userCart.isEmpty;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── SLIVER APP BAR ──────────────────────
              SliverAppBar(
                expandedHeight: 110,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: appBarBg,
                elevation: 0,
                scrolledUnderElevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16, top: 8, bottom: 8),
                    // child: ThemeToggleButton(
                    //   surfaceColor: surfaceColor,
                    //   borderColor: borderColor,
                    //   size: 38,
                    // ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(
                      left: 24, bottom: 16),
                  title: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      // ✅ Title restored
                      Text(
                        'My Cart',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (!isEmpty) ...[
                        const SizedBox(width: 10),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 3),
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF8B5CF6),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${value.userCart.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          appBarGradTop,
                          scaffoldBg,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── EMPTY STATE ─────────────────────────
              if (isEmpty)
                SliverFillRemaining(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: _EmptyCart(
                        onShopNow: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const ShopPage()),
                        ),
                      ),
                    ),
                  ),
                )

              // ── CART ITEMS ──────────────────────────
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entries = value
                            .userCart.entries
                            .toList();
                        return FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(
                                      bottom: 12),
                              child: CartItem(
                                product:
                                    entries[index].key,
                                quantity:
                                    entries[index].value,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: value.userCart.length,
                    ),
                  ),
                ),

                // ── ORDER SUMMARY ───────────────────
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      // ✅ Extra bottom padding so summary
                      //    clears the floating bottom nav
                      padding: const EdgeInsets.fromLTRB(
                          20, 8, 20, 110),
                      child: _OrderSummaryCard(
                        total: value.getTotalPrice(),
                        itemCount: value.userCart.length,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        primaryText: primaryText,
                        onCheckout: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const PaymentMethod()),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ── ORDER SUMMARY CARD ────────────────────────────────────────────────────────
class _OrderSummaryCard extends StatelessWidget {
  final double total;
  final int itemCount;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final VoidCallback onCheckout;

  const _OrderSummaryCard({
    required this.total,
    required this.itemCount,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF8B5CF6);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);
    final valueText =
        isDark ? Colors.white70 : const Color(0xFF374151);
    final totalRowBg = isDark
        ? Colors.white.withOpacity(0.04)
        : const Color(0xFFF1EEFF);

    // ✅ GHS shipping threshold: free above GHS 200
    final shippingFree = total > 200;
    final shippingCost = shippingFree ? 0.0 : 15.0;
    final tax = total * 0.025; // 2.5% VAT (Ghana)
    final grandTotal = total + shippingCost + tax;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color:
                purple.withOpacity(isDark ? 0.12 : 0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [

          // ── Header ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                22, 20, 22, 16),
            child: Row(
              children: [
                Text('Order Summary',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: purple.withOpacity(0.12),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$itemCount item${itemCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: borderColor, height: 1),

          // ── Price rows ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 16),
            child: Column(
              children: [
                _PriceRow(
                  label: 'Subtotal',
                  // ✅ GHS currency
                  value:
                      'GHS ${total.toStringAsFixed(2)}',
                  labelColor: secondaryText,
                  valueColor: valueText,
                ),
                const SizedBox(height: 10),
                _PriceRow(
                  label: 'Shipping',
                  value: shippingFree
                      ? 'Free 🎉'
                      : 'GHS ${shippingCost.toStringAsFixed(2)}',
                  labelColor: secondaryText,
                  valueColor: shippingFree
                      ? const Color(0xFF34D399)
                      : valueText,
                ),
                const SizedBox(height: 10),
                _PriceRow(
                  label: 'VAT (2.5%)',
                  value:
                      'GHS ${tax.toStringAsFixed(2)}',
                  labelColor: secondaryText,
                  valueColor: valueText,
                ),
              ],
            ),
          ),

          // ── Grand total row ───────────────────────
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 16),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: totalRowBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  // ✅ GHS currency
                  'GHS ${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: purple,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Checkout button ───────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                16, 0, 16, 20),
            child: _CheckoutButton(onTap: onCheckout),
          ),

          // ── Free shipping nudge ───────────────────
          if (!shippingFree)
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 18),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                      Icons.local_shipping_outlined,
                      size: 14,
                      color: Color(0xFF34D399)),
                  const SizedBox(width: 6),
                  Text(
                    'Add GHS ${(200 - total).toStringAsFixed(2)} more for free shipping',
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

// ── Price row ─────────────────────────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: labelColor, fontSize: 14)),
        Text(value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}

// ── Checkout button ───────────────────────────────────────────────────────────
class _CheckoutButton extends StatefulWidget {
  final VoidCallback onTap;
  const _CheckoutButton({required this.onTap});

  @override
  State<_CheckoutButton> createState() =>
      _CheckoutButtonState();
}

class _CheckoutButtonState extends State<_CheckoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7C3AED),
                Color(0xFF8B5CF6),
                Color(0xFFA78BFA),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6)
                    .withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Proceed to Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty cart ────────────────────────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  final VoidCallback onShopNow;
  const _EmptyCart({required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleText = isDark
        ? Colors.white.withOpacity(0.4)
        : const Color(0xFF94A3B8);
    final iconRingColor = isDark
        ? const Color(0xFF8B5CF6).withOpacity(0.08)
        : const Color(0xFF8B5CF6).withOpacity(0.06);
    final iconBorderColor = isDark
        ? const Color(0xFF8B5CF6).withOpacity(0.2)
        : const Color(0xFF8B5CF6).withOpacity(0.25);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconRingColor,
                border: Border.all(
                    color: iconBorderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6)
                        .withOpacity(
                            isDark ? 0.15 : 0.1),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 48,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 28),
            Text('Your cart is empty',
              style: TextStyle(
                color: primaryText,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Looks like you haven\'t added\nanything to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subtitleText,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            GestureDetector(
              onTap: onShopNow,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 36, vertical: 16),
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
                      BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6)
                          .withOpacity(
                              isDark ? 0.4 : 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.storefront_outlined,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Shop Now',
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
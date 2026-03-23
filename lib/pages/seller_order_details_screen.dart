
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/theme_toggle_button.dart';

class SellerOrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const SellerOrderDetailsScreen(
      {super.key, required this.order});

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':   return const Color(0xFFF59E0B);
      case 'Packaging': return const Color(0xFF06B6D4);
      case 'Delivered': return const Color(0xFF34D399);
      default:          return const Color(0xFF8B5CF6);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Pending':   return Icons.hourglass_empty_rounded;
      case 'Packaging': return Icons.inventory_2_rounded;
      case 'Delivered': return Icons.check_circle_rounded;
      default:          return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFEEF1FB);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    final status = order['status'] as String;
    final statusColor = _statusColor(status);
    final statusIcon  = _statusIcon(status);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
            bottom: BorderSide(color: borderColor)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryText,
              size: 16,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order['id']}',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              order['date'] as String,
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          // ✅ Theme toggle
          Padding(
            padding: const EdgeInsets.only(
                right: 16, top: 8, bottom: 8),
            child: ThemeToggleButton(
              surfaceColor: scaffoldBg,
              borderColor: borderColor,
              size: 38,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
            16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Status banner ─────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color:
                          statusColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(statusIcon,
                        color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order is $status',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order['date'] as String,
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          statusColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      'GHS ${order['amount']}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Verification code ─────────────────
            _SectionCard(
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.qr_code_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Verification Code',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8F9FF),
                      borderRadius:
                          BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6)
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '7 0 9 7 9 5',
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // Copy to clipboard
                          },
                          child: Text(
                            'Tap to copy',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Address info ──────────────────────
            _SectionCard(
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: const Color(
                                      0xFF06B6D4)
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(
                                      10),
                            ),
                            child: const Icon(
                              Icons
                                  .location_on_rounded,
                              color: Color(0xFF06B6D4),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('Address Info',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                                    0xFF06B6D4)
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                                    20),
                          ),
                          child: const Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.map_rounded,
                                color:
                                    Color(0xFF06B6D4),
                                size: 13,
                              ),
                              SizedBox(width: 5),
                              Text('Map',
                                style: TextStyle(
                                  color:
                                      Color(0xFF06B6D4),
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _AddressBlock(
                    type: 'Shipping',
                    name: 'Kwame Asante',
                    phone: '+233 241 234 567',
                    address: 'Market Street, Tarkwa',
                    color: const Color(0xFF8B5CF6),
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    cardBg: cardBg,
                  ),

                  Divider(
                      color: borderColor,
                      height: 24),

                  _AddressBlock(
                    type: 'Billing',
                    name: 'Kwame Asante',
                    phone: '+233 241 234 567',
                    address: 'Market Street, Tarkwa',
                    color: const Color(0xFF34D399),
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    cardBg: cardBg,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Order items ───────────────────────
            _SectionCard(
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B)
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons
                              .shopping_bag_rounded,
                          color: Color(0xFFF59E0B),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Order Items',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _OrderItemRow(
                    name: "Women's Shoes",
                    price: 'GHS 250.00',
                    qty: 1,
                    isDark: isDark,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    cardBg: cardBg,
                  ),

                  Divider(
                      color: borderColor, height: 24),

                  // Price breakdown
                  _PriceRow(
                    label: 'Subtotal',
                    value: 'GHS 5,000.00',
                    labelColor: secondaryText,
                    valueColor: primaryText,
                  ),
                  const SizedBox(height: 8),
                  _PriceRow(
                    label: 'Tax (2.5%)',
                    value: '+ GHS 125.00',
                    labelColor: secondaryText,
                    valueColor:
                        const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 8),
                  _PriceRow(
                    label: 'Discount',
                    value: '- GHS 500.00',
                    labelColor: secondaryText,
                    valueColor:
                        const Color(0xFF34D399),
                  ),

                  const SizedBox(height: 12),

                  // Grand total
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF1EEFF),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'GHS 4,625.00',
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Action buttons ────────────────────
            if (status == 'Pending') ...[
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Accept & Pack',
                      icon: Icons
                          .inventory_2_rounded,
                      color:
                          const Color(0xFF34D399),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior
                                .floating,
                            backgroundColor: isDark
                                ? const Color(
                                    0xFF1E1B2E)
                                : Colors.white,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      14),
                            ),
                            margin:
                                const EdgeInsets.all(
                                    16),
                            content: const Row(
                              children: [
                                Icon(
                                  Icons
                                      .check_circle_rounded,
                                  color: Color(
                                      0xFF34D399),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Order accepted & moved to Packaging',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Cancel',
                      icon: Icons.close_rounded,
                      color: const Color(0xFFEF4444),
                      isOutlined: true,
                      onTap: () =>
                          _showCancelDialog(
                              context, isDark),
                    ),
                  ),
                ],
              ),
            ] else if (status == 'Packaging') ...[
              _ActionButton(
                label: 'Mark as Delivered',
                icon: Icons
                    .local_shipping_rounded,
                color: const Color(0xFF06B6D4),
                fullWidth: true,
                onTap: () {
                  HapticFeedback.lightImpact();
                },
              ),
            ] else if (status == 'Delivered') ...[
              _ActionButton(
                label: 'Download Receipt',
                icon: Icons.download_rounded,
                color: const Color(0xFF8B5CF6),
                fullWidth: true,
                onTap: () {
                  HapticFeedback.lightImpact();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, bool isDark) {
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE2E8F0);

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
            Container(
              width: 36, height: 4,
              margin:
                  const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel_rounded,
                color: Color(0xFFEF4444),
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text('Cancel Order?',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will cancel the order.\nThe buyer will be notified.',
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
                    onPressed: () =>
                        Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                      side: BorderSide(
                          color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Keep Order',
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
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFEF4444),
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Yes, Cancel',
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
}

// ── Section card wrapper ──────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color surfaceColor;
  final Color borderColor;

  const _SectionCard({
    required this.child,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Address block ─────────────────────────────────────────────────────────────
class _AddressBlock extends StatelessWidget {
  final String type;
  final String name;
  final String phone;
  final String address;
  final Color color;
  final Color primaryText;
  final Color secondaryText;
  final Color cardBg;

  const _AddressBlock({
    required this.type,
    required this.name,
    required this.phone,
    required this.address,
    required this.color,
    required this.primaryText,
    required this.secondaryText,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            type == 'Shipping'
                ? Icons.local_shipping_rounded
                : Icons.receipt_rounded,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(type,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(name,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(phone,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                ),
              ),
              Text(address,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Order item row ────────────────────────────────────────────────────────────
class _OrderItemRow extends StatelessWidget {
  final String name;
  final String price;
  final int qty;
  final bool isDark;
  final Color primaryText;
  final Color secondaryText;
  final Color cardBg;

  const _OrderItemRow({
    required this.name,
    required this.price,
    required this.qty,
    required this.isDark,
    required this.primaryText,
    required this.secondaryText,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: isDark
                ? Colors.white.withOpacity(0.3)
                : const Color(0xFFCBD5E1),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(name,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text('Qty: $qty',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(price,
          style: const TextStyle(
            color: Color(0xFF8B5CF6),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: labelColor, fontSize: 13)),
        Text(value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isOutlined;
  final bool fullWidth;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isOutlined = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
            vertical: 15),
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : color,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined
              ? Border.all(color: color, width: 1.5)
              : null,
          boxShadow: isOutlined
              ? []
              : [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isOutlined
                    ? color
                    : Colors.white,
                size: 18),
            const SizedBox(width: 8),
            Text(label,
              style: TextStyle(
                color: isOutlined
                    ? color
                    : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );

    return fullWidth ? child : Expanded(child: child);
  }
}
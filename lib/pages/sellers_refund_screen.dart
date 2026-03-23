
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/theme_toggle_button.dart';

class SellerRefundScreen extends StatefulWidget {
  final Map<String, dynamic> order;
  const SellerRefundScreen(
      {super.key, required this.order});

  @override
  State<SellerRefundScreen> createState() =>
      _SellerRefundScreenState();
}

class _SellerRefundScreenState
    extends State<SellerRefundScreen> {
  String? _selectedReason;
  final TextEditingController _commentController =
      TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _refundReasons = [
    {
      'label': 'Customer returned item',
      'icon': Icons.undo_rounded,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'label': 'Item damaged during delivery',
      'icon': Icons.broken_image_rounded,
      'color': const Color(0xFFEF4444),
    },
    {
      'label': 'Wrong item delivered',
      'icon': Icons.swap_horiz_rounded,
      'color': const Color(0xFFF59E0B),
    },
    {
      'label': 'Customer changed mind',
      'icon': Icons.psychology_rounded,
      'color': const Color(0xFF06B6D4),
    },
    {
      'label': 'Order not delivered',
      'icon': Icons.local_shipping_rounded,
      'color': const Color(0xFFE83A8A),
    },
    {
      'label': 'Other (please explain)',
      'icon': Icons.more_horiz_rounded,
      'color': const Color(0xFF94A3B8),
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':   return const Color(0xFFF59E0B);
      case 'Packaging': return const Color(0xFF06B6D4);
      case 'Delivered': return const Color(0xFF34D399);
      default:          return const Color(0xFF8B5CF6);
    }
  }

  Future<void> _submitRefund() async {
    if (_selectedReason == null) {
      _showSnackbar(
        'Please select a refund reason',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    _showSnackbar('Refund request submitted successfully');
    Navigator.pop(context);
  }

  void _showSnackbar(String msg,
      {bool isError = false}) {
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
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: (isError
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF34D399))
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_rounded,
                color: isError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF34D399),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(msg,
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final order = widget.order;
    final status = order['status'] as String? ?? 'Unknown';
    final statusColor = _statusColor(status);

    // ── Theme tokens ──────────────────────────────
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
    final inputFill = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFEEF1FB);
    final hintColor = isDark
        ? Colors.white.withOpacity(0.25)
        : const Color(0xFFADB5C7);

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
            Text('Refund Request',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text('Order #${order['id']}',
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

            // ── Order info banner ─────────────────
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
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color:
                          statusColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order['id']}',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          order['date'] as String? ??
                              '',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor
                                    .withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(
                                        20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text('Amount',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'GHS\n${order['amount']}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Section label ─────────────────────
            _SectionHeader(
              icon: Icons.help_outline_rounded,
              label: 'Reason for Refund',
              subtitle: 'Select the most applicable reason',
              color: const Color(0xFF8B5CF6),
              primaryText: primaryText,
              secondaryText: secondaryText,
            ),

            const SizedBox(height: 14),

            // ── Reason chips ──────────────────────
            ...  _refundReasons.map((reason) {
              final label = reason['label'] as String;
              final icon  = reason['icon'] as IconData;
              final color = reason['color'] as Color;
              final isSelected = _selectedReason == label;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(
                      () => _selectedReason = label);
                },
                child: AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 200),
                  margin: const EdgeInsets.only(
                      bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.1)
                        : surfaceColor,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? color.withOpacity(0.4)
                          : borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color
                                  .withOpacity(0.1),
                              blurRadius: 12,
                              offset:
                                  const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      // Icon container
                      AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 200),
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.15)
                              : cardBg,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Icon(icon,
                          color: isSelected
                              ? color
                              : secondaryText,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(label,
                          style: TextStyle(
                            color: isSelected
                                ? color
                                : primaryText,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      // Selection indicator
                      AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 200),
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? color
                                : borderColor,
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 13,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // ── Comments section ──────────────────
            _SectionHeader(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Additional Comments',
              subtitle: 'Optional — describe the issue',
              color: const Color(0xFF06B6D4),
              primaryText: primaryText,
              secondaryText: secondaryText,
            ),

            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: TextFormField(
                controller: _commentController,
                style: TextStyle(
                    color: primaryText, fontSize: 14),
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Describe the issue or add more details...',
                  hintStyle: TextStyle(
                      color: hintColor, fontSize: 13),
                  filled: true,
                  fillColor: inputFill,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.8,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Policy note ───────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B)
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF59E0B)
                      .withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your refund request will be reviewed within 48 hours. '
                      "We'll notify you once it's processed.",
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFFF59E0B)
                                .withOpacity(0.8)
                            : const Color(0xFF92400E),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Action buttons ────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pop(context),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                            color: borderColor,
                            width: 1.5),
                      ),
                      child: Center(
                        child: Text('Cancel',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Submit
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _isSubmitting
                        ? null
                        : _submitRefund,
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 200),
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 15),
                      decoration: BoxDecoration(
                        gradient: _isSubmitting
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Color(0xFF7C3AED),
                                  Color(0xFF8B5CF6),
                                ],
                                begin: Alignment
                                    .centerLeft,
                                end: Alignment
                                    .centerRight,
                              ),
                        color: _isSubmitting
                            ? const Color(0xFF8B5CF6)
                                .withOpacity(0.5)
                            : null,
                        borderRadius:
                            BorderRadius.circular(16),
                        boxShadow: _isSubmitting
                            ? []
                            : [
                                BoxShadow(
                                  color: const Color(
                                          0xFF8B5CF6)
                                      .withOpacity(
                                          0.4),
                                  blurRadius: 16,
                                  offset: const Offset(
                                      0, 4),
                                ),
                              ],
                      ),
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons
                                        .send_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Submit Request',
                                    style: TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      letterSpacing:
                                          0.2,
                                    ),
                                  ),
                                ],
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
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color primaryText;
  final Color secondaryText;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
              style: TextStyle(
                color: primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Text(subtitle,
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
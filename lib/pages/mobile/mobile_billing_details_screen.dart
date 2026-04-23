import 'package:comfi/pages/billing_details_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileBillingDetailsScreen extends StatefulWidget {
  final OrderItem item;
  final List<DeliveryOption> deliveryOptions;
  final UserAddress? savedAddress;

  const MobileBillingDetailsScreen({
    super.key,
    required this.item,
    required this.deliveryOptions,
    this.savedAddress,
  });

  @override
  State<MobileBillingDetailsScreen> createState() =>
      _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<MobileBillingDetailsScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  late DeliveryOption _selectedDelivery;
  MomoProvider _selectedMomo = MomoProvider.mtn;
  PaymentStatus _paymentStatus = PaymentStatus.idle;
  late UserAddress _address;
  final TextEditingController _phoneCtrl = TextEditingController(
    text: '055 123 4567',
  );
  final bool _isLoadingTotal = false;
  OrderTotal? _orderTotal;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _selectedDelivery = widget.deliveryOptions.first;
    _address = widget.savedAddress ?? defaultBillingAddress;

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    _animCtrl.forward();
    _computeTotal();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  // ── Compute total (preview — real total must come from backend) ────────────
  void _computeTotal() {
    setState(() {
      _orderTotal = OrderTotal.compute(
        effectivePrice: widget.item.effectivePrice,
        originalPrice: widget.item.originalPrice,
        deliveryFee: _selectedDelivery.fee,
      );
    });
  }

  void _onDeliveryChanged(DeliveryOption opt) {
    setState(() => _selectedDelivery = opt);
    _computeTotal();
  }

  // ── Payment flow ───────────────────────────────────────────────────────────
  Future<void> _initiatePayment() async {
    if (_orderTotal == null) return;
    HapticFeedback.mediumImpact();

    setState(() => _paymentStatus = PaymentStatus.pending);

    // Show the "Check Your Phone" bottom sheet
    await _showPaymentPendingSheet();
  }

  Future<void> _showPaymentPendingSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => _PaymentPendingSheet(
        provider: _selectedMomo,
        phone: _phoneCtrl.text,
        total: _orderTotal!.total,
        currency: widget.item.currency,
        onSuccess: () {
          Navigator.pop(context);
          setState(() => _paymentStatus = PaymentStatus.success);
          _showSuccessScreen();
        },
        onFailure: (reason) {
          Navigator.pop(context);
          setState(() => _paymentStatus = PaymentStatus.failed);
          _showErrorSheet(reason);
        },
      ),
    );
  }

  void _showSuccessScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          item: widget.item,
          total: _orderTotal!,
          deliveryOption: _selectedDelivery,
        ),
      ),
    );
  }

  void _showErrorSheet(String reason) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHandle(color: borderColor),
            const SizedBox(height: 20),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Payment Failed',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reason,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText.withOpacity(0.5),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _OutlineButton(
                    label: 'Change Method',
                    onTap: () => Navigator.pop(context),
                    textColor: primaryText,
                    borderColor: borderColor,
                    bgColor: isDark
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFEEF1FB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PrimaryButton(
                    label: 'Try Again',
                    onTap: () {
                      Navigator.pop(context);
                      _initiatePayment();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: _buildAppBar(
        isDark,
        scaffoldBg,
        surfaceColor,
        borderColor,
        primaryText,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                children: [
                  // 1. Product Summary
                  _SectionLabel(label: 'Product', secondaryText: secondaryText),
                  const SizedBox(height: 8),
                  _ProductSummaryCard(
                    item: widget.item,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),

                  const SizedBox(height: 20),

                  // 2. Seller Info
                  _SectionLabel(label: 'Seller', secondaryText: secondaryText),
                  const SizedBox(height: 8),
                  _SellerCard(
                    item: widget.item,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),

                  const SizedBox(height: 20),

                  // 3. Delivery
                  _SectionLabel(
                    label: 'Delivery',
                    secondaryText: secondaryText,
                  ),
                  const SizedBox(height: 8),
                  _DeliveryCard(
                    options: widget.deliveryOptions,
                    selected: _selectedDelivery,
                    address: _address,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    onChanged: _onDeliveryChanged,
                    onEditAddress: () {
                      /* navigate to address editor */
                    },
                  ),

                  const SizedBox(height: 20),

                  // 4. Payment Method
                  _SectionLabel(
                    label: 'Payment Method',
                    secondaryText: secondaryText,
                  ),
                  const SizedBox(height: 8),
                  _MomoPaymentCard(
                    selected: _selectedMomo,
                    phoneCtrl: _phoneCtrl,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    onProviderChanged: (p) => setState(() => _selectedMomo = p),
                  ),

                  const SizedBox(height: 20),

                  // 5. Escrow Banner
                  _EscrowBanner(
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                  ),

                  const SizedBox(height: 20),

                  // 6. Price Breakdown
                  _SectionLabel(
                    label: 'Price Breakdown',
                    secondaryText: secondaryText,
                  ),
                  const SizedBox(height: 8),
                  _PriceBreakdownCard(
                    item: widget.item,
                    total: _orderTotal,
                    isLoading: _isLoadingTotal,
                    isDark: isDark,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                ],
              ),

              // ── Bottom CTA ────────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomCTA(
                  total: _orderTotal?.total,
                  currency: widget.item.currency,
                  isLoading: _paymentStatus == PaymentStatus.pending,
                  onPay: _initiatePayment,
                  scaffoldBg: scaffoldBg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    bool isDark,
    Color scaffoldBg,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
  ) {
    return AppBar(
      backgroundColor: scaffoldBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: surfaceColor,
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
      title: Text(
        'Billing Details',
        style: TextStyle(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8B5CF6).withOpacity(0.25),
            ),
          ),
          child: const Text(
            'Step 2/3',
            style: TextStyle(
              color: Color(0xFF8B5CF6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SECTION COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════

// ── Product Summary Card ──────────────────────────────────────────────────────
class _ProductSummaryCard extends StatelessWidget {
  final OrderItem item;
  final bool isDark;
  final Color surfaceColor, borderColor, primaryText, secondaryText;

  const _ProductSummaryCard({
    required this.item,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      isDark: isDark,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _OrderItemPreviewImage(imageUrl: item.imageUrl, size: 72),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.sellerRating > 0
                      ? 'Sold by ${item.sellerName} | ${item.sellerRating.toStringAsFixed(1)} rating'
                      : 'Sold by ${item.sellerName}',
                  style: TextStyle(fontSize: 11.5, color: secondaryText),
                ),
                const SizedBox(height: 8),
                if (item.quantity > 1) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Qty ${item.quantity}',
                      style: const TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    if (item.hasNegotiatedPrice) ...[
                      Text(
                        '${item.currency} ${item.originalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: secondaryText.withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: secondaryText.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '${item.currency} ${item.effectivePrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    if (item.hasNegotiatedPrice) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34D399).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Saved ${item.currency} ${item.savings.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemPreviewImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const _OrderItemPreviewImage({required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    final path = imageUrl?.trim();
    if (path == null || path.isEmpty) {
      return _ProductPlaceholder(size: size);
    }

    final image = path.startsWith('http://') || path.startsWith('https://')
        ? Image.network(
            path,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _ProductPlaceholder(size: size),
          )
        : Image.asset(
            path,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _ProductPlaceholder(size: size),
          );

    return SizedBox(width: size, height: size, child: image);
  }
}

class _ProductPlaceholder extends StatelessWidget {
  final double size;
  const _ProductPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: const Color(0xFF8B5CF6).withOpacity(0.4),
        size: size * 0.4,
      ),
    );
  }
}

// ── Seller Card ───────────────────────────────────────────────────────────────
class _SellerCard extends StatelessWidget {
  final OrderItem item;
  final bool isDark;
  final Color surfaceColor, borderColor, primaryText, secondaryText;

  const _SellerCard({
    required this.item,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      isDark: isDark,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
              ),
            ),
            child: Center(
              child: Text(
                item.sellerName.isNotEmpty
                    ? item.sellerName[0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.sellerName,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                    if (item.sellerVerified) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF10B981),
                              size: 11,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Responds in ~10 min  •  98% positive',
                  style: TextStyle(fontSize: 11.5, color: secondaryText),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              /* navigate to chat */
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                ),
              ),
              child: const Text(
                'Chat',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Delivery Card ─────────────────────────────────────────────────────────────
class _DeliveryCard extends StatelessWidget {
  final List<DeliveryOption> options;
  final DeliveryOption selected;
  final UserAddress address;
  final bool isDark;
  final Color surfaceColor, borderColor, primaryText, secondaryText;
  final ValueChanged<DeliveryOption> onChanged;
  final VoidCallback onEditAddress;

  const _DeliveryCard({
    required this.options,
    required this.selected,
    required this.address,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.onChanged,
    required this.onEditAddress,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      isDark: isDark,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      child: Column(
        children: [
          ...options.map(
            (opt) => _DeliveryOptionTile(
              option: opt,
              isSelected: opt.id == selected.id,
              isDark: isDark,
              borderColor: borderColor,
              primaryText: primaryText,
              secondaryText: secondaryText,
              onTap: () => onChanged(opt),
            ),
          ),
          if (selected.type == DeliveryType.home) ...[
            const SizedBox(height: 4),
            _AddressTile(
              address: address,
              isDark: isDark,
              primaryText: primaryText,
              secondaryText: secondaryText,
              onEdit: onEditAddress,
            ),
          ],
        ],
      ),
    );
  }
}

class _DeliveryOptionTile extends StatelessWidget {
  final DeliveryOption option;
  final bool isSelected;
  final bool isDark;
  final Color borderColor, primaryText, secondaryText;
  final VoidCallback onTap;

  const _DeliveryOptionTile({
    required this.option,
    required this.isSelected,
    required this.isDark,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6).withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6).withOpacity(0.35)
                : borderColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF8B5CF6)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8B5CF6)
                      : secondaryText.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 8, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'GHS ${option.fee.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    option.subtitle,
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      option.timeEstimate,
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

class _AddressTile extends StatelessWidget {
  final UserAddress address;
  final bool isDark;
  final Color primaryText, secondaryText;
  final VoidCallback onEdit;

  const _AddressTile({
    required this.address,
    required this.isDark,
    required this.primaryText,
    required this.secondaryText,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1723) : const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: const Color(0xFF8B5CF6),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.line1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
                if (address.line2 != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    address.line2!,
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
                if (address.ghanaPostGps != null ||
                    address.landmark != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    [
                      if (address.ghanaPostGps != null) address.ghanaPostGps!,
                      if (address.landmark != null) address.landmark!,
                    ].join('  •  '),
                    style: TextStyle(
                      fontSize: 11,
                      color: secondaryText.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mobile Money Card ─────────────────────────────────────────────────────────
class _MomoPaymentCard extends StatelessWidget {
  final MomoProvider selected;
  final TextEditingController phoneCtrl;
  final bool isDark;
  final Color surfaceColor, borderColor, primaryText, secondaryText;
  final ValueChanged<MomoProvider> onProviderChanged;

  const _MomoPaymentCard({
    required this.selected,
    required this.phoneCtrl,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.onProviderChanged,
  });

  static const _providers = [
    (MomoProvider.mtn, 'MTN MoMo', Color(0xFFF59E0B)),
    (MomoProvider.vodafone, 'Vodafone', Color(0xFFEF4444)),
    (MomoProvider.airteltigo, 'AirtelTigo', Color(0xFF3B82F6)),
  ];

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      isDark: isDark,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Provider',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _providers.map((p) {
              final (provider, label, color) = p;
              final isActive = selected == provider;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onProviderChanged(provider);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      right: provider != MomoProvider.airteltigo ? 8 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF8B5CF6).withOpacity(0.08)
                          : isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFEEF1FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF8B5CF6).withOpacity(0.4)
                            : borderColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              label[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label.split(' ')[0],
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isActive
                                ? const Color(0xFF8B5CF6)
                                : secondaryText,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // Phone input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1723) : const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Text(
                  '🇬🇭  +233',
                  style: TextStyle(fontSize: 13.5, color: secondaryText),
                ),
                Container(
                  width: 1,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: borderColor,
                ),
                Expanded(
                  child: TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 14, color: primaryText),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: '055 000 0000',
                      hintStyle: TextStyle(
                        color: secondaryText.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: secondaryText.withOpacity(0.6),
              ),
              const SizedBox(width: 5),
              Text(
                'You\'ll receive a USSD prompt on this number',
                style: TextStyle(
                  fontSize: 11,
                  color: secondaryText.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Escrow Banner ─────────────────────────────────────────────────────────────
class _EscrowBanner extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor, borderColor, primaryText;

  const _EscrowBanner({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Trust banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.07),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secured by Comfi Escrow',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your money is held safely. The seller only receives payment after you confirm delivery.',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 11.5,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Escrow step timeline
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border(
              left: BorderSide(color: const Color(0xFF10B981).withOpacity(0.2)),
              right: BorderSide(
                color: const Color(0xFF10B981).withOpacity(0.2),
              ),
              bottom: BorderSide(
                color: const Color(0xFF10B981).withOpacity(0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              _EscrowStep(
                label: 'You pay',
                icon: Icons.payments_outlined,
                active: true,
              ),
              _EscrowConnector(active: true),
              _EscrowStep(
                label: 'Seller ships',
                icon: Icons.local_shipping_outlined,
                active: true,
              ),
              _EscrowConnector(active: false),
              _EscrowStep(
                label: 'You confirm',
                icon: Icons.check_circle_outline,
                active: false,
              ),
              _EscrowConnector(active: false),
              _EscrowStep(
                label: 'Funds released',
                icon: Icons.account_balance_wallet_outlined,
                active: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EscrowStep extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;

  const _EscrowStep({
    required this.label,
    required this.icon,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFF8B5CF6).withOpacity(0.15)
                : Colors.white.withOpacity(0.04),
            border: Border.all(
              color: active
                  ? const Color(0xFF8B5CF6).withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 14,
            color: active
                ? const Color(0xFF8B5CF6)
                : Colors.white.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 48,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              height: 1.3,
              color: active
                  ? Colors.white.withOpacity(0.8)
                  : Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }
}

class _EscrowConnector extends StatelessWidget {
  final bool active;
  const _EscrowConnector({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.only(bottom: 24),
        color: active
            ? const Color(0xFF8B5CF6).withOpacity(0.3)
            : Colors.white.withOpacity(0.06),
      ),
    );
  }
}

// ── Price Breakdown Card ──────────────────────────────────────────────────────
class _PriceBreakdownCard extends StatelessWidget {
  final OrderItem item;
  final OrderTotal? total;
  final bool isLoading;
  final bool isDark;
  final Color surfaceColor, borderColor, primaryText, secondaryText;

  const _PriceBreakdownCard({
    required this.item,
    required this.total,
    required this.isLoading,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || total == null) {
      return _SettingsCard(
        isDark: isDark,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B5CF6),
            strokeWidth: 2,
          ),
        ),
      );
    }

    return _SettingsCard(
      isDark: isDark,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      child: Column(
        children: [
          _BreakdownRow(
            label: 'Item price',
            value: '${item.currency} ${total!.itemPrice.toStringAsFixed(2)}',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          if (item.hasNegotiatedPrice) ...[
            Divider(height: 1, color: borderColor),
            _BreakdownRow(
              label: 'Negotiated discount',
              value: '− ${item.currency} ${total!.discount.toStringAsFixed(2)}',
              primaryText: const Color(0xFF34D399),
              secondaryText: const Color(0xFF34D399),
            ),
          ],
          Divider(height: 1, color: borderColor),
          _BreakdownRow(
            label: 'Delivery fee',
            value: '${item.currency} ${total!.deliveryFee.toStringAsFixed(2)}',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          Divider(height: 1, color: borderColor),
          _BreakdownRow(
            label: 'Service fee (2.5%)',
            value: '${item.currency} ${total!.serviceFee.toStringAsFixed(2)}',
            primaryText: primaryText,
            secondaryText: secondaryText,
            tooltipText: 'Platform fee to keep Comfi running',
          ),
          Divider(height: 1, color: borderColor),
          _BreakdownRow(
            label: 'VAT (15% on service)',
            value: '${item.currency} ${total!.tax.toStringAsFixed(2)}',
            primaryText: primaryText,
            secondaryText: secondaryText,
            tooltipText: 'Ghana Revenue Authority standard VAT',
          ),
          const SizedBox(height: 6),
          Divider(thickness: 1, color: borderColor),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              Text(
                '${item.currency} ${total!.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final Color primaryText, secondaryText;
  final String? tooltipText;

  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.primaryText,
    required this.secondaryText,
    this.tooltipText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: secondaryText)),
          if (tooltipText != null) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: tooltipText!,
              child: Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: secondaryText.withOpacity(0.5),
              ),
            ),
          ],
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom CTA ────────────────────────────────────────────────────────────────
class _BottomCTA extends StatelessWidget {
  final double? total;
  final String currency;
  final bool isLoading;
  final VoidCallback onPay;
  final Color scaffoldBg;

  const _BottomCTA({
    required this.total,
    required this.currency,
    required this.isLoading,
    required this.onPay,
    required this.scaffoldBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [scaffoldBg.withOpacity(0), scaffoldBg],
          stops: const [0, 0.35],
        ),
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onPay,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      total != null
                          ? 'Pay $currency ${total!.toStringAsFixed(2)} securely'
                          : 'Calculating...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PAYMENT PENDING BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

class _PaymentPendingSheet extends StatefulWidget {
  final MomoProvider provider;
  final String phone;
  final double total;
  final String currency;
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  const _PaymentPendingSheet({
    required this.provider,
    required this.phone,
    required this.total,
    required this.currency,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<_PaymentPendingSheet> createState() => _PaymentPendingSheetState();
}

class _PaymentPendingSheetState extends State<_PaymentPendingSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  int _countdown = 60;
  late final _timer = Stream.periodic(
    const Duration(seconds: 1),
    (i) => i,
  ).take(60).listen(_onTick);

  String get _providerName => switch (widget.provider) {
    MomoProvider.mtn => 'MTN Mobile Money',
    MomoProvider.vodafone => 'Vodafone Cash',
    MomoProvider.airteltigo => 'AirtelTigo Money',
  };

  Color get _providerColor => switch (widget.provider) {
    MomoProvider.mtn => const Color(0xFFF59E0B),
    MomoProvider.vodafone => const Color(0xFFEF4444),
    MomoProvider.airteltigo => const Color(0xFF3B82F6),
  };

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  void _onTick(int i) {
    if (!mounted) return;
    setState(() => _countdown = 59 - i);
    if (_countdown <= 0) {
      _timer.cancel();
      widget.onFailure('Payment timed out. Please try again.');
    }
    // In production: poll backend every 5s here
    // if (i % 5 == 0) _pollStatus();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(color: borderColor),
          const SizedBox(height: 28),

          // Pulsing phone icon
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Transform.scale(
              scale: 1.0 + (_pulseCtrl.value * 0.06),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _providerColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _providerColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.phone_android_rounded,
                  color: _providerColor,
                  size: 32,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'Check your phone',
            style: TextStyle(
              color: primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: secondaryText,
                fontSize: 13.5,
                height: 1.6,
              ),
              children: [
                const TextSpan(text: 'A payment prompt was sent via '),
                TextSpan(
                  text: _providerName,
                  style: TextStyle(
                    color: _providerColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' to\n'),
                TextSpan(
                  text: widget.phone,
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: '.\nEnter your PIN to confirm payment.'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Amount pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withOpacity(0.25),
              ),
            ),
            child: Text(
              '${widget.currency} ${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, size: 14, color: secondaryText),
              const SizedBox(width: 5),
              Text(
                'Expires in ${_countdown}s',
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),
            ],
          ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: () => widget.onFailure('Payment cancelled.'),
            child: Text(
              'Cancel',
              style: TextStyle(color: secondaryText, fontSize: 13),
            ),
          ),

          // ── DEV ONLY — remove in production ──────────────────────────
          // Quick success/failure simulation:
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onFailure.bind(
                    null,
                    'Insufficient funds on your account.',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                  ),
                  child: const Text(
                    'Simulate Fail',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onSuccess,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF34D399),
                  ),
                  child: const Text(
                    'Simulate Success',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ORDER SUCCESS SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class OrderSuccessScreen extends StatelessWidget {
  final OrderItem item;
  final OrderTotal total;
  final DeliveryOption deliveryOption;

  const OrderSuccessScreen({
    super.key,
    required this.item,
    required this.total,
    required this.deliveryOption,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399).withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF34D399).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF34D399),
                  size: 38,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Confirmed!',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your payment is secured with Comfi Escrow.\nYou\'ll be notified when your order ships.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // Summary card
              _SettingsCard(
                isDark: isDark,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                child: Column(
                  children: [
                    _BreakdownRow(
                      label: 'Order ID',
                      value:
                          '#CMF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    Divider(height: 1, color: borderColor),
                    _BreakdownRow(
                      label: 'Item',
                      value: item.name.length > 22
                          ? '${item.name.substring(0, 22)}…'
                          : item.name,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    Divider(height: 1, color: borderColor),
                    _BreakdownRow(
                      label: 'Total paid',
                      value:
                          '${item.currency} ${total.total.toStringAsFixed(2)}',
                      primaryText: const Color(0xFF8B5CF6),
                      secondaryText: secondaryText,
                    ),
                    Divider(height: 1, color: borderColor),
                    _BreakdownRow(
                      label: 'Delivery',
                      value: deliveryOption.timeEstimate,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Track order button
              _PrimaryButton(
                label: 'Track My Order',
                onTap: () {
                  /* navigate to order tracking */
                },
              ),
              const SizedBox(height: 12),
              _OutlineButton(
                label: 'Continue Shopping',
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                textColor: primaryText,
                borderColor: borderColor,
                bgColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SHARED UTILITY WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor, borderColor;
  final Widget child;

  const _SettingsCard({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color secondaryText;

  const _SectionLabel({required this.label, required this.secondaryText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  final Color color;
  const _SheetHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color textColor, borderColor, bgColor;

  const _OutlineButton({
    required this.label,
    required this.onTap,
    required this.textColor,
    required this.borderColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper extension for binding callbacks ────────────────────────────────────
extension FunctionBind<A> on ValueChanged<A> {
  VoidCallback bind(_, A arg) =>
      () => this(arg);
}

// ═══════════════════════════════════════════════════════════════════════════════
//  USAGE EXAMPLE
// ═══════════════════════════════════════════════════════════════════════════════
//
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => BillingDetailsScreen(
//       item: OrderItem(
//         id: 'prod_001',
//         name: 'Nike Air Max 270 — Black/White',
//         sellerName: 'KofiSneaks',
//         sellerRating: 4.8,
//         sellerVerified: true,
//         originalPrice: 380,
//         negotiatedPrice: 310,   // from offer/negotiation
//         currency: 'GHS',
//       ),
//       deliveryOptions: [
//         DeliveryOption(
//           id: 'home_gig',
//           title: 'Home Delivery',
//           subtitle: 'Delivered by GIG Logistics',
//           fee: 25,
//           timeEstimate: '2–4 business days',
//           type: DeliveryType.home,
//         ),
//         DeliveryOption(
//           id: 'pickup_agent',
//           title: 'Pickup Station',
//           subtitle: 'Collect from a nearby agent hub',
//           fee: 8,
//           timeEstimate: 'Ready in 1–2 days',
//           type: DeliveryType.pickup,
//         ),
//       ],
//     ),
//   ),
// );

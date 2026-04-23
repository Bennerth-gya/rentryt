import 'dart:io';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/pages/buyers_billing_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../consts/theme_toggle_button.dart';

class ProductDetailsPage extends StatefulWidget {
  final Products product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  String? _selectedColor;
  String? _selectedSize;
  bool _isProcessing = false;
  bool _isFavourited = false;
  int _quantity = 1;
  int _selectedImageIndex = 0;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late final List<String> _images;

  @override
  void initState() {
    super.initState();

    _images = widget.product.imagePaths;

    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showSnackbar(String msg, {bool isError = false}) {
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
                color:
                    (isError
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF34D399))
                        .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isError ? Icons.error_outline_rounded : Icons.check_rounded,
                color: isError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF34D399),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateAddToCart() {
    HapticFeedback.lightImpact();
    Provider.of<Cart>(context, listen: false).addItemToCart(widget.product);
    _showSnackbar('${widget.product.name} added to cart!');
  }

  Future<void> _handleBuyNow() async {
    final product = widget.product;

    if (_selectedSize == null && product.sizes.isNotEmpty) {
      _showSnackbar('Please select a size first', isError: true);
      return;
    }
    if (_selectedColor == null && product.colors.isNotEmpty) {
      _showSnackbar('Please select a color first', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    final checkoutData = BillingDetailsRouteData.fromProduct(
      product,
      quantity: _quantity,
      selectedColor: _selectedColor,
      selectedSize: _selectedSize,
    );

    try {
      final cart = Provider.of<Cart>(context, listen: false);
      for (var i = 0; i < _quantity; i++) {
        await cart.addItemToCart(product);
      }

      if (!mounted) {
        return;
      }

      await Navigator.pushNamed(
        context,
        AppRoutes.payment,
        arguments: checkoutData,
      );
    } catch (_) {
      if (mounted) {
        _showSnackbar(
          'Unable to open billing details right now',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleNegotiate() async {
    HapticFeedback.selectionClick();
    await Navigator.pushNamed(
      context,
      AppRoutes.negotiationChat,
      arguments: NegotiationChatRouteData(product: widget.product),
    );
  }

  /// Launch the phone dialer with the seller's number
  Future<void> _callSeller(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackbar('Could not open dialer', isError: true);
    }
  }

  // ── Seller avatar widget ──────────────────────────────────────────────────
  Widget _buildSellerAvatar(String? imagePath, {double size = 52}) {
    final placeholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF8B5CF6).withOpacity(0.12),
      ),
      child: Icon(
        Icons.person_rounded,
        color: const Color(0xFF8B5CF6).withOpacity(0.6),
        size: size * 0.45,
      ),
    );

    if (imagePath == null || imagePath.isEmpty) {
      return placeholder;
    }

    final isAsset = imagePath.startsWith('assets/');
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.35),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: isAsset
            ? Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              )
            : Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaSize = MediaQuery.sizeOf(context);
    final safeTop = MediaQuery.paddingOf(context).top;
    final product = widget.product;
    final screenWidth = mediaSize.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;
    final contentMaxWidth = isTablet ? 820.0 : double.infinity;
    final heroAspectRatio = isTablet ? 1.45 : isSmallScreen ? 0.95 : 1.0;
    final heroTopSpacing = safeTop + kToolbarHeight + 12;
    final actionSpacerHeight = isSmallScreen ? 196.0 : 176.0;
    final sectionSpacing = isTablet ? 28.0 : 24.0;
    final thumbnailSize = isSmallScreen ? 52.0 : 58.0;
    final images = _images.where((path) => path.trim().isNotEmpty).toList();
    final gallery = images.isEmpty ? <String>[product.imagePath] : images;
    final currentImageIndex = _selectedImageIndex >= gallery.length
        ? 0
        : _selectedImageIndex;
    final totalPrice = product.price * _quantity;

    final scaffoldBg = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);

    Widget buildProductImage(
      String imagePath, {
      double? width,
      double? height,
      BoxFit fit = BoxFit.cover,
    }) {
      final normalized = imagePath.trim();
      final placeholder = Container(
        width: width,
        height: height,
        color: cardBg,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: isSmallScreen ? 44 : 64,
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : const Color(0xFFCBD5E1),
        ),
      );

      if (normalized.isEmpty) {
        return placeholder;
      }

      final Widget image;
      if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
        image = Image.network(
          normalized,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => placeholder,
        );
      } else if (normalized.startsWith('assets/')) {
        image = Image.asset(
          normalized,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => placeholder,
        );
      } else {
        image = Image.file(
          File(normalized),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => placeholder,
        );
      }

      return image;
    }

    Widget buildActionButton({
      required VoidCallback? onTap,
      required Widget child,
      required BoxDecoration decoration,
    }) {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              height: 52,
              decoration: decoration,
              child: Center(child: child),
            ),
          ),
        ),
      );
    }

    Widget buildCartButton() {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _simulateAddToCart,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFF8B5CF6),
              size: 22,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      extendBodyBehindAppBar: true,

      // ── APP BAR ──────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryText,
              size: 16,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: ThemeToggleButton(
              surfaceColor: Colors.transparent,
              borderColor: Colors.transparent,
              size: 38,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _isFavourited = !_isFavourited);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.4)
                    : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                _isFavourited
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _isFavourited ? const Color(0xFFE83A8A) : primaryText,
                size: 18,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: Icon(Icons.share_rounded, color: primaryText, size: 18),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    heroTopSpacing,
                    horizontalPadding,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Stack(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: ClipRRect(
                              key: ValueKey(gallery[currentImageIndex]),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 28 : 22,
                              ),
                              child: AspectRatio(
                                aspectRatio: heroAspectRatio,
                                child: buildProductImage(
                                  gallery[currentImageIndex],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 28 : 22,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      scaffoldBg.withOpacity(0.78),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: isTablet ? null : 16,
                            bottom: 16,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: isTablet ? 220 : screenWidth * 0.55,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (gallery.length > 1)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        child: SizedBox(
                          height: thumbnailSize,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: gallery.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (_, i) {
                              final isSelected = i == currentImageIndex;
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedImageIndex = i);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: thumbnailSize,
                                  height: thumbnailSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF8B5CF6)
                                          : borderColor,
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF8B5CF6,
                                              ).withOpacity(0.35),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: ClipOval(
                                    child: buildProductImage(
                                      gallery[i],
                                      width: thumbnailSize,
                                      height: thumbnailSize,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final compactHeader = constraints.maxWidth < 420;
                                final priceBadge = Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34D399).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF34D399)
                                          .withOpacity(0.25),
                                    ),
                                  ),
                                  child: Text(
                                    'GHS ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF34D399),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                );

                                if (compactHeader) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: primaryText,
                                          fontSize: isTablet ? 26 : 22,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      priceBadge,
                                    ],
                                  );
                                }

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: primaryText,
                                          fontSize: isTablet ? 26 : 22,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    priceBadge,
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            if (product.averageRating != null &&
                                product.reviewCount != null) ...[
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(5, (i) {
                                      final value = i + 1.0;
                                      return Icon(
                                        value <= product.averageRating!
                                            ? Icons.star_rounded
                                            : value - 0.5 <= product.averageRating!
                                                ? Icons.star_half_rounded
                                                : Icons.star_outline_rounded,
                                        color: const Color(0xFFFBBF24),
                                        size: 18,
                                      );
                                    }),
                                  ),
                                  Text(
                                    product.averageRating!.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: primaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '(${product.reviewCount} reviews)',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final compactQuantity = constraints.maxWidth < 360;
                                final selector = Container(
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _QtyButton(
                                        icon: Icons.remove_rounded,
                                        onTap: () {
                                          if (_quantity > 1) {
                                            HapticFeedback.selectionClick();
                                            setState(() => _quantity--);
                                          }
                                        },
                                        isDark: isDark,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          '$_quantity',
                                          style: TextStyle(
                                            color: primaryText,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      _QtyButton(
                                        icon: Icons.add_rounded,
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          setState(() => _quantity++);
                                        },
                                        isDark: isDark,
                                        isAdd: true,
                                      ),
                                    ],
                                  ),
                                );

                                if (compactQuantity) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          color: primaryText,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      selector,
                                    ],
                                  );
                                }

                                return Row(
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(
                                        color: primaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    selector,
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: sectionSpacing),
                            if (product.colors.isNotEmpty) ...[
                              _SectionLabel(
                                label: 'Color',
                                selected: _selectedColor,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: isSmallScreen ? 44 : 48,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: product.colors.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, i) {
                                    final name = product.colors[i];
                                    final color = getProductColor(name);
                                    final isSelected = _selectedColor == name;
                                    return GestureDetector(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        setState(() => _selectedColor = name);
                                      },
                                      child: Tooltip(
                                        message: name,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: isSmallScreen ? 42 : 44,
                                          height: isSmallScreen ? 42 : 44,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFF8B5CF6)
                                                  : borderColor,
                                              width: isSelected ? 3 : 1.5,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFF8B5CF6,
                                                      ).withOpacity(0.35),
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 3),
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          child: isSelected
                                              ? Icon(
                                                  Icons.check_rounded,
                                                  size: 18,
                                                  color: color.computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Colors.white,
                                                )
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: sectionSpacing),
                            ],
                            if (product.sizes.isNotEmpty) ...[
                              _SectionLabel(
                                label: 'Size',
                                selected: _selectedSize,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: product.sizes.map((size) {
                                  final isSelected = _selectedSize == size;
                                  return GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setState(() => _selectedSize = size);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF8B5CF6)
                                                .withOpacity(0.15)
                                            : surfaceColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF8B5CF6)
                                              : borderColor,
                                          width: isSelected ? 1.8 : 1,
                                        ),
                                      ),
                                      child: Text(
                                        size,
                                        style: TextStyle(
                                          color: isSelected
                                              ? const Color(0xFF8B5CF6)
                                              : secondaryText,
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: sectionSpacing),
                            ],
                            Text(
                              'Description',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                product.description.isNotEmpty
                                    ? product.description
                                    : 'No description available.',
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 14.5,
                                  height: 1.65,
                                ),
                              ),
                            ),
                            SizedBox(height: sectionSpacing),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final useThreeColumns = constraints.maxWidth > 420;
                                const spacing = 8.0;
                                final chipWidth = useThreeColumns
                                    ? (constraints.maxWidth - (spacing * 2)) / 3
                                    : (constraints.maxWidth - spacing) / 2;

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: [
                                    SizedBox(
                                      width: chipWidth,
                                      child: _InfoChip(
                                        icon: Icons.local_shipping_outlined,
                                        label: 'Fast Delivery',
                                        isDark: isDark,
                                        surfaceColor: surfaceColor,
                                        borderColor: borderColor,
                                        secondaryText: secondaryText,
                                      ),
                                    ),
                                    SizedBox(
                                      width: chipWidth,
                                      child: _InfoChip(
                                        icon: Icons.verified_outlined,
                                        label: 'Verified Seller',
                                        isDark: isDark,
                                        surfaceColor: surfaceColor,
                                        borderColor: borderColor,
                                        secondaryText: secondaryText,
                                      ),
                                    ),
                                    SizedBox(
                                      width: chipWidth,
                                      child: _InfoChip(
                                        icon: Icons.refresh_rounded,
                                        label: 'Easy Return',
                                        isDark: isDark,
                                        surfaceColor: surfaceColor,
                                        borderColor: borderColor,
                                        secondaryText: secondaryText,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: isTablet ? 32 : 28),
                            if (product.sellerName != null ||
                                product.sellerPhone != null ||
                                product.sellerLocation != null) ...[
                              Text(
                                'Seller Information',
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withOpacity(0.15)
                                          : const Color(0xFF8B5CF6)
                                              .withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildSellerAvatar(
                                          product.sellerImagePath,
                                          size: 56,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  if (product.sellerName != null)
                                                    Text(
                                                      product.sellerName!,
                                                      style: TextStyle(
                                                        color: primaryText,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: -0.2,
                                                      ),
                                                    ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF34D399,
                                                      ).withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20,
                                                      ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFF34D399,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.verified_rounded,
                                                          color:
                                                              Color(0xFF34D399),
                                                          size: 11,
                                                        ),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          'Verified',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF34D399,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (product.sellerLocation !=
                                                  null) ...[
                                                const SizedBox(height: 6),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on_rounded,
                                                      size: 14,
                                                      color: Color(0xFF8B5CF6),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        product.sellerLocation!,
                                                        style: TextStyle(
                                                          color: secondaryText,
                                                          fontSize: 12.5,
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (product.sellerPhone != null) ...[
                                      const SizedBox(height: 14),
                                      Divider(color: borderColor, height: 1),
                                      const SizedBox(height: 14),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final compactPhone =
                                              constraints.maxWidth < 360;
                                          final phoneMeta = Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Phone',
                                                  style: TextStyle(
                                                    color: secondaryText,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                Text(
                                                  product.sellerPhone!,
                                                  style: TextStyle(
                                                    color: primaryText,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          final callButton = buildActionButton(
                                            onTap: () =>
                                                _callSeller(product.sellerPhone!),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF7C3AED),
                                                  Color(0xFF8B5CF6),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF8B5CF6)
                                                      .withOpacity(0.35),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.call_rounded,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Call Seller',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (compactPhone) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 36,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFF8B5CF6,
                                                        ).withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          10,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.phone_rounded,
                                                        color:
                                                            Color(0xFF8B5CF6),
                                                        size: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    phoneMeta,
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                callButton,
                                              ],
                                            );
                                          }

                                          return Row(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF8B5CF6,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.phone_rounded,
                                                  color: Color(0xFF8B5CF6),
                                                  size: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              phoneMeta,
                                              const SizedBox(width: 12),
                                              SizedBox(
                                                width: 132,
                                                child: callButton,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(height: isTablet ? 32 : 28),
                            ],
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Customer Reviews',
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                                Text(
                                  'See all',
                                  style: TextStyle(
                                    color:
                                        const Color(0xFF8B5CF6).withOpacity(0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final compactReview =
                                          constraints.maxWidth < 360;

                                      if (compactReview) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF8B5CF6,
                                                    ).withOpacity(0.12),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'K',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF8B5CF6),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Kwame A.',
                                                        style: TextStyle(
                                                          color: primaryText,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Row(
                                                        children:
                                                            List.generate(
                                                          5,
                                                          (i) => const Icon(
                                                            Icons.star_rounded,
                                                            color: Color(
                                                              0xFFFBBF24,
                                                            ),
                                                            size: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '2 days ago',
                                                style: TextStyle(
                                                  color: secondaryText,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF8B5CF6)
                                                  .withOpacity(0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'K',
                                                style: TextStyle(
                                                  color: Color(0xFF8B5CF6),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Kwame A.',
                                                  style: TextStyle(
                                                    color: primaryText,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (i) => const Icon(
                                                      Icons.star_rounded,
                                                      color: Color(0xFFFBBF24),
                                                      size: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '2 days ago',
                                            style: TextStyle(
                                              color: secondaryText,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Great product! Exactly as described. Fast delivery too.',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 13.5,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: actionSpacerHeight),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SlideTransition(
        position: _slideAnim,
        child: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding,
              16,
            ),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(top: BorderSide(color: borderColor)),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total price',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 12,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'GHS ${totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    buildCartButton(),
                  ],
                ),
                const SizedBox(height: 12),
                if (isSmallScreen) ...[
                  buildActionButton(
                    onTap: _handleNegotiate,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF0F766E).withOpacity(0.25),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum_rounded,
                          color: Color(0xFF0F766E),
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Negotiate Price',
                          style: TextStyle(
                            color: Color(0xFF0F766E),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildActionButton(
                    onTap: _isProcessing ? null : _handleBuyNow,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flash_on_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: buildActionButton(
                          onTap: _handleNegotiate,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF0F766E).withOpacity(0.25),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.forum_rounded,
                                color: Color(0xFF0F766E),
                                size: 14,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Negotiate Price',
                                style: TextStyle(
                                  color: Color(0xFF0F766E),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: buildActionButton(
                          onTap: _isProcessing ? null : _handleBuyNow,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.flash_on_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Buy Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quantity button ───────────────────────────────────────────────────────────
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool isAdd;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isAdd
              ? const Color(0xFF8B5CF6).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isAdd
              ? const Color(0xFF8B5CF6)
              : isDark
              ? Colors.white.withOpacity(0.6)
              : const Color(0xFF64748B),
          size: 18,
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final String? selected;
  final bool isDark;

  const _SectionLabel({
    required this.label,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (selected != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              selected!,
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Info chip ─────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color secondaryText;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF8B5CF6), size: 18),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

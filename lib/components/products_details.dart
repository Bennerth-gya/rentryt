import 'dart:io';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../consts/theme_toggle_button.dart';

class ProductDetailsPage extends StatefulWidget {
  final Products product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
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

  void _showSnackbar(String msg, {bool isError = false}) {
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
  Widget _buildSellerAvatar(String? imagePath,
      {double size = 52}) {
    final placeholder = Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF8B5CF6).withOpacity(0.12),
      ),
      child: Icon(Icons.person_rounded,
          color: const Color(0xFF8B5CF6).withOpacity(0.6),
          size: size * 0.45),
    );

    if (imagePath == null || imagePath.isEmpty) {
      return placeholder;
    }

    final isAsset = imagePath.startsWith('assets/');
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.35),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: isAsset
            ? Image.asset(imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder)
            : Image.file(File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = widget.product;

    final scaffoldBg    = isDark ? const Color(0xFF080C14)  : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827)  : Colors.white;
    final cardBg        = isDark ? const Color(0xFF1F2937)  : const Color(0xFFEEF1FB);
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white             : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.5)  : const Color(0xFF64748B);

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
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: primaryText, size: 16),
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
                color: _isFavourited
                    ? const Color(0xFFE83A8A)
                    : primaryText,
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
            child: Icon(Icons.share_rounded,
                color: primaryText, size: 18),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ── HERO IMAGE ────────────────────────────
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: AspectRatio(
                      key: ValueKey(_selectedImageIndex),
                      aspectRatio: 1.0,
                      child: Image.asset(
                        _images[_selectedImageIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: cardBg,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            scaffoldBg.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(product.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── THUMBNAIL ROW ────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: List.generate(
                    _images.length,
                    (i) {
                      final isSelected = i == _selectedImageIndex;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedImageIndex = i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 58, height: 58,
                          margin: const EdgeInsets.only(right: 10),
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
                                      color: const Color(0xFF8B5CF6)
                                          .withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : [],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              _images[i],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: cardBg,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 22,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.2)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── CONTENT ──────────────────────────────
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Name + price row
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(product.name,
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF34D399)
                                  .withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(12),
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Rating row
                      if (product.averageRating != null &&
                          product.reviewCount != null) ...[
                        Row(
                          children: [
                            ...List.generate(5, (i) {
                              final v = i + 1.0;
                              return Icon(
                                v <= product.averageRating!
                                    ? Icons.star_rounded
                                    : v - 0.5 <=
                                            product.averageRating!
                                        ? Icons.star_half_rounded
                                        : Icons.star_outline_rounded,
                                color: const Color(0xFFFBBF24),
                                size: 18,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              product.averageRating!
                                  .toStringAsFixed(1),
                              style: TextStyle(
                                color: primaryText,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
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

                      // Quantity selector
                      Row(
                        children: [
                          Text('Quantity',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius:
                                  BorderRadius.circular(12),
                              border:
                                  Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                _QtyButton(
                                  icon: Icons.remove_rounded,
                                  onTap: () {
                                    if (_quantity > 1) {
                                      HapticFeedback
                                          .selectionClick();
                                      setState(
                                          () => _quantity--);
                                    }
                                  },
                                  isDark: isDark,
                                ),
                                Padding(
                                  padding: const EdgeInsets
                                      .symmetric(horizontal: 16),
                                  child: Text('$_quantity',
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
                                    HapticFeedback
                                        .selectionClick();
                                    setState(() => _quantity++);
                                  },
                                  isDark: isDark,
                                  isAdd: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Colors ───────────────────────────
                      if (product.colors.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Color',
                          selected: _selectedColor,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 48,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.colors.length,
                            itemBuilder: (_, i) {
                              final name = product.colors[i];
                              final col = getProductColor(name);
                              final selected =
                                  _selectedColor == name;
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() =>
                                      _selectedColor = name);
                                },
                                child: Tooltip(
                                  message: name,
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 200),
                                    width: 44, height: 44,
                                    margin: const EdgeInsets.only(
                                        right: 10),
                                    decoration: BoxDecoration(
                                      color: col,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? const Color(
                                                0xFF8B5CF6)
                                            : borderColor,
                                        width: selected ? 3 : 1.5,
                                      ),
                                      boxShadow: selected
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                        0xFF8B5CF6)
                                                    .withOpacity(0.4),
                                                blurRadius: 10,
                                                offset: const Offset(
                                                    0, 3),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: selected
                                        ? Icon(
                                            Icons.check_rounded,
                                            size: 18,
                                            color: col.computeLuminance() >
                                                    0.5
                                                ? Colors.black
                                                : Colors.white)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── Sizes ────────────────────────────
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
                            final selected =
                                _selectedSize == size;
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(
                                    () => _selectedSize = size);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 200),
                                padding: const EdgeInsets
                                    .symmetric(
                                        horizontal: 16,
                                        vertical: 10),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF8B5CF6)
                                          .withOpacity(0.15)
                                      : surfaceColor,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFF8B5CF6)
                                        : borderColor,
                                    width: selected ? 1.8 : 1,
                                  ),
                                ),
                                child: Text(size,
                                  style: TextStyle(
                                    color: selected
                                        ? const Color(0xFF8B5CF6)
                                        : secondaryText,
                                    fontSize: 13,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── Description ──────────────────────
                      Text('Description',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius:
                              BorderRadius.circular(16),
                          border:
                              Border.all(color: borderColor),
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

                      const SizedBox(height: 24),

                      // ── Delivery info chips ──────────────
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.local_shipping_outlined,
                            label: 'Fast Delivery',
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            secondaryText: secondaryText,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon: Icons.verified_outlined,
                            label: 'Verified Seller',
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            secondaryText: secondaryText,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon: Icons.refresh_rounded,
                            label: 'Easy Return',
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            secondaryText: secondaryText,
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ══════════════════════════════════════
                      // SELLER INFO CARD
                      // ══════════════════════════════════════
                      if (product.sellerName != null ||
                          product.sellerPhone != null ||
                          product.sellerLocation != null) ...[
                        Text('Seller Information',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius:
                                BorderRadius.circular(20),
                            border:
                                Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black
                                        .withOpacity(0.15)
                                    : const Color(0xFF8B5CF6)
                                        .withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Top row: avatar + name + location
                              Row(
                                children: [
                                  // Seller avatar
                                  _buildSellerAvatar(
                                      product.sellerImagePath,
                                      size: 56),
                                  const SizedBox(width: 14),

                                  // Name + location
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (product.sellerName !=
                                            null)
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
                                        const SizedBox(height: 4),
                                        if (product.sellerLocation !=
                                            null)
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .location_on_rounded,
                                                size: 13,
                                                color: const Color(
                                                    0xFF8B5CF6),
                                              ),
                                              const SizedBox(
                                                  width: 3),
                                              Expanded(
                                                child: Text(
                                                  product
                                                      .sellerLocation!,
                                                  style: TextStyle(
                                                    color:
                                                        secondaryText,
                                                    fontSize: 12.5,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Verified badge
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF34D399)
                                          .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            const Color(0xFF34D399)
                                                .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: Color(0xFF34D399),
                                          size: 11,
                                        ),
                                        const SizedBox(width: 3),
                                        const Text('Verified',
                                          style: TextStyle(
                                            color:
                                                Color(0xFF34D399),
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

                              // Divider
                              if (product.sellerPhone != null) ...[
                                const SizedBox(height: 14),
                                Divider(
                                    color: borderColor, height: 1),
                                const SizedBox(height: 14),

                                // Phone row with call button
                                Row(
                                  children: [
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                                0xFF8B5CF6)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(
                                                10),
                                      ),
                                      child: const Icon(
                                        Icons.phone_rounded,
                                        color: Color(0xFF8B5CF6),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Phone',
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
                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Call button
                                    GestureDetector(
                                      onTap: () => _callSeller(
                                          product.sellerPhone!),
                                      child: Container(
                                        height: 38,
                                        padding: const EdgeInsets
                                            .symmetric(
                                                horizontal: 16),
                                        decoration: BoxDecoration(
                                          gradient:
                                              const LinearGradient(
                                            colors: [
                                              Color(0xFF7C3AED),
                                              Color(0xFF8B5CF6),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                      0xFF8B5CF6)
                                                  .withOpacity(0.35),
                                              blurRadius: 10,
                                              offset: const Offset(
                                                  0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            Icon(
                                                Icons.call_rounded,
                                                color: Colors.white,
                                                size: 14),
                                            SizedBox(width: 5),
                                            Text('Call',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
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
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // ── Reviews header ───────────────────
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer Reviews',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text('See all',
                            style: TextStyle(
                              color: const Color(0xFF8B5CF6)
                                  .withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Review card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius:
                              BorderRadius.circular(16),
                          border:
                              Border.all(color: borderColor),
                        ),
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
                                        .withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text('K',
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
                                      Text('Kwame A.',
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
                                            color: Color(
                                                0xFFFBBF24),
                                            size: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('2 days ago',
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
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

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── BOTTOM ACTION BUTTONS ───────────────────────
      bottomNavigationBar: SlideTransition(
        position: _slideAnim,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Total price',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'GHS ${(product.price * _quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add to cart
                GestureDetector(
                  onTap: _simulateAddToCart,
                  child: Container(
                    width: 52, height: 52,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6)
                          .withOpacity(0.12),
                      borderRadius:
                          BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF8B5CF6),
                      size: 22,
                    ),
                  ),
                ),

                // Buy now
                GestureDetector(
                  onTap: _isProcessing
                      ? null
                      : () {
                          if (_selectedSize == null &&
                              product.sizes.isNotEmpty) {
                            _showSnackbar(
                                'Please select a size first',
                                isError: true);
                            return;
                          }
                          if (_selectedColor == null &&
                              product.colors.isNotEmpty) {
                            _showSnackbar(
                                'Please select a color first',
                                isError: true);
                            return;
                          }
                          Provider.of<Cart>(context, listen: false)
                              .addItemToCart(product);
                          Navigator.pushNamed(context, AppRoutes.payment);
                        },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28),
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
                          BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flash_on_rounded,
                                  color: Colors.white,
                                  size: 18),
                              SizedBox(width: 6),
                              Text('Buy Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                  ),
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
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: isAdd
              ? const Color(0xFF8B5CF6).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
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
    return Row(
      children: [
        Text(label,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (selected != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(selected!,
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: const Color(0xFF8B5CF6), size: 18),
            const SizedBox(height: 5),
            Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

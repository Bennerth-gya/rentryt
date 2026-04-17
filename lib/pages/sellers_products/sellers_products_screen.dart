// sellers_products/sellers_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellersProductsScreen extends StatefulWidget {
  const SellersProductsScreen({super.key});

  @override
  State<SellersProductsScreen> createState() => _SellersProductsScreenState();
}

class _SellersProductsScreenState extends State<SellersProductsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _headerController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _headerSlide;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Out of Stock', 'Draft'];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Hot Plate',
      'price': 680.0,
      'rating': 4.4,
      'image': 'assets/images/hotplate.jpg',
      'sales': 124,
      'stock': 18,
      'status': 'Active',
      'category': 'Electronics',
    },
    {
      'name': "Men's Shirt",
      'price': 100.0,
      'rating': 4.0,
      'image': 'assets/images/men_shirt1.jpg',
      'sales': 89,
      'stock': 42,
      'status': 'Active',
      'category': 'Clothing',
    },
    {
      'name': 'Study Lamp',
      'price': 690.0,
      'rating': 4.4,
      'image': 'assets/images/study_lamp.jpg',
      'sales': 57,
      'stock': 0,
      'status': 'Out of Stock',
      'category': 'Electronics',
    },
    {
      'name': "Men's Slippers",
      'price': 399.0,
      'rating': 3.6,
      'image': 'assets/images/slipper2.jpg',
      'sales': 203,
      'stock': 7,
      'status': 'Active',
      'category': 'Shoes',
    },
    {
      'name': 'Wireless Earbuds',
      'price': 850.0,
      'rating': 4.7,
      'image': 'assets/images/hotplate.jpg',
      'sales': 310,
      'stock': 25,
      'status': 'Active',
      'category': 'Electronics',
    },
    {
      'name': 'Canvas Backpack',
      'price': 220.0,
      'rating': 4.2,
      'image': 'assets/images/men_shirt1.jpg',
      'sales': 68,
      'stock': 0,
      'status': 'Draft',
      'category': 'Accessories',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedFilter == 'All') return products;
    return products
        .where((p) => p['status'] == _selectedFilter)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));

    _headerController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Theme Tokens ─────────────────────────────────────────────────────────
    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF0F2FF);
    final surfaceBg     = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg        = isDark ? const Color(0xFF161D2F) : Colors.white;
    final primaryText   = isDark ? Colors.white             : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF64748B);
    final borderColor   = isDark ? Colors.white.withOpacity(0.07) : const Color(0xFFE2E8F0);
    final accent        = const Color(0xFF6B4EFF);
    final accentSoft    = accent.withOpacity(0.12);
    final successColor  = isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    final warningColor  = isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);
    final errorColor    = isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
    final statCardBg    = isDark ? const Color(0xFF1A2235) : const Color(0xFFEEF1FF);

    final filteredList  = _filteredProducts;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── HEADER ──────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _headerSlide,
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceBg,
                      border: Border(
                        bottom: BorderSide(color: borderColor),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 16,
                                  color: primaryText,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Title + subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Products',
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    '${products.length} products listed',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Search icon
                            _IconBtn(
                              icon: Icons.search_rounded,
                              onTap: () {},
                              bg: isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : const Color(0xFFF1F5F9),
                            borderColor: borderColor,
                              iconColor: primaryText,
                            ),
                            const SizedBox(width: 8),

                            // Add product icon
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7C3AED),
                                      Color(0xFF6B4EFF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accent.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── STATS ROW ────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      _StatCard(
                        label: 'Total Sales',
                        value: '851',
                        icon: Icons.trending_up_rounded,
                        iconBg: successColor.withOpacity(0.15),
                        iconColor: successColor,
                        bg: statCardBg,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Revenue',
                        value: 'GHS 12.4k',
                        icon: Icons.attach_money_rounded,
                        iconBg: accent.withOpacity(0.15),
                        iconColor: accent,
                        bg: statCardBg,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'In Stock',
                        value: '${products.where((p) => (p['stock'] as int) > 0).length}',
                        icon: Icons.inventory_2_rounded,
                        iconBg: warningColor.withOpacity(0.15),
                        iconColor: warningColor,
                        bg: statCardBg,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                    ],
                  ),
                ),
              ),

              // ── FILTER CHIPS ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Listings',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(right: 20),
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final f = _filters[i];
                            final selected = f == _selectedFilter;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedFilter = f),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14),
                                decoration: BoxDecoration(
                                  color: selected ? accent : accentSoft,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected
                                        ? accent
                                        : borderColor,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color:
                                                accent.withOpacity(0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    f,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: selected
                                          ? Colors.white
                                          : secondaryText,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── PRODUCT GRID ─────────────────────────────────────────────────
              filteredList.isEmpty
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: accentSoft,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.inventory_2_outlined,
                                    color: accent.withOpacity(0.5), size: 28),
                              ),
                              const SizedBox(height: 14),
                              Text('No products here',
                                  style: TextStyle(
                                      color: primaryText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              const SizedBox(height: 6),
                              Text('Try a different filter',
                                  style: TextStyle(
                                      color: secondaryText, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final p = filteredList[index];
                            final outOfStock = (p['stock'] as int) == 0;
                            final isDraft = p['status'] == 'Draft';

                            Color statusColor;
                            String statusLabel;
                            if (isDraft) {
                              statusColor = secondaryText;
                              statusLabel = 'Draft';
                            } else if (outOfStock) {
                              statusColor = errorColor;
                              statusLabel = 'Out of Stock';
                            } else {
                              statusColor = successColor;
                              statusLabel = 'Active';
                            }

                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: borderColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withOpacity(0.25)
                                          : Colors.black.withOpacity(0.05),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Image ───────────────────────────────
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(18)),
                                          child: Image.asset(
                                            p['image'],
                                            height: 140,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                              height: 140,
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.white
                                                        .withOpacity(0.04)
                                                    : const Color(0xFFF1F5F9),
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            18)),
                                              ),
                                              child: Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: secondaryText,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Status badge
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: statusColor
                                                      .withOpacity(0.3)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    color: statusColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  statusLabel,
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // More options
                                        Positioned(
                                          top: 6,
                                          right: 6,
                                          child: GestureDetector(
                                            onTap: () =>
                                                _showProductOptions(context,
                                                    p, isDark, primaryText,
                                                    surfaceBg, borderColor),
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.black.withOpacity(0.35),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.more_horiz_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ── Info ─────────────────────────────────
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: primaryText,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            p['category'],
                                            style: TextStyle(
                                              color: secondaryText,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'GHS ${p['price'].toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: accent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              // Rating
                                              Icon(Icons.star_rounded,
                                                  color: Colors.amber, size: 13),
                                              const SizedBox(width: 3),
                                              Text(
                                                '${p['rating']}',
                                                style: TextStyle(
                                                  color: secondaryText,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Spacer(),
                                              // Sales badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: accentSoft,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${p['sales']} sold',
                                                  style: TextStyle(
                                                    color: accent,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Stock bar
                                          _StockBar(
                                            stock: p['stock'] as int,
                                            successColor: successColor,
                                            warningColor: warningColor,
                                            errorColor: errorColor,
                                            secondaryText: secondaryText,
                                            borderColor: borderColor,
                                            isDark: isDark,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: filteredList.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.52,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                      ),
                    ),
            ],
          ),
        ),

        // ── FAB ──────────────────────────────────────────────────────────────
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: accent,
          elevation: 6,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  void _showProductOptions(
    BuildContext context,
    Map<String, dynamic> p,
    bool isDark,
    Color primaryText,
    Color surfaceBg,
    Color borderColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              p['name'],
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _OptionTile(
              icon: Icons.edit_rounded,
              label: 'Edit Product',
              color: const Color(0xFF6B4EFF),
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.visibility_off_rounded,
              label: 'Deactivate Listing',
              color: Colors.orange,
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Product',
              color: Colors.red,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stock Bar ─────────────────────────────────────────────────────────────────
class _StockBar extends StatelessWidget {
  final int stock;
  final Color successColor, warningColor, errorColor, secondaryText, borderColor;
  final bool isDark;

  const _StockBar({
    required this.stock,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.secondaryText,
    required this.borderColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color barColor = stock == 0
        ? errorColor
        : stock < 10
            ? warningColor
            : successColor;
    final double fill = stock == 0 ? 0 : (stock / 50).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stock',
              style: TextStyle(color: secondaryText, fontSize: 9),
            ),
            Text(
              stock == 0 ? 'None' : '$stock units',
              style: TextStyle(
                color: barColor,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: fill,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconBg, iconColor, bg, primaryText, secondaryText;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.bg,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 15),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: secondaryText, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Icon Button ───────────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg, borderColor, iconColor;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.bg,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}

// ── Option Tile ───────────────────────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }
}
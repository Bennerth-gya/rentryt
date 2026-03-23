
import 'package:comfi/consts/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellersCustomersScreen extends StatefulWidget {
  const SellersCustomersScreen({super.key});

  @override
  State<SellersCustomersScreen> createState() =>
      _SellersCustomersScreenState();
}

class _SellersCustomersScreenState
    extends State<SellersCustomersScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController =
      TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0; // 0=All 1=Top 2=New

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Ama Mensah',
      'email': 'ama.mensah@gmail.com',
      'phone': '+233 24 123 4567',
      'orders': 12,
      'totalSpent': 3450.00,
      'joined': 'Jan 2025',
      'color': Color(0xFF8B5CF6),
      'isTop': true,
    },
    {
      'name': 'Kwame Boateng',
      'email': 'kwameb@outlook.com',
      'phone': '+233 54 987 6543',
      'orders': 8,
      'totalSpent': 1820.50,
      'joined': 'Mar 2025',
      'color': Color(0xFF06B6D4),
      'isTop': false,
    },
    {
      'name': 'Efua Osei',
      'email': 'efua.osei@yahoo.com',
      'phone': '+233 27 555 8888',
      'orders': 25,
      'totalSpent': 7890.00,
      'joined': 'Feb 2025',
      'color': Color(0xFFE83A8A),
      'isTop': true,
    },
    {
      'name': 'Yaw Asante',
      'email': 'yaw.asante@icloud.com',
      'phone': '+233 20 111 2222',
      'orders': 3,
      'totalSpent': 540.00,
      'joined': 'Apr 2025',
      'color': Color(0xFF34D399),
      'isTop': false,
    },
    {
      'name': 'Abena Darkwah',
      'email': 'abena.d@gmail.com',
      'phone': '+233 26 777 3344',
      'orders': 18,
      'totalSpent': 5120.75,
      'joined': 'Dec 2024',
      'color': Color(0xFFF59E0B),
      'isTop': true,
    },
    {
      'name': 'Kofi Frimpong',
      'email': 'kofi.f@hotmail.com',
      'phone': '+233 57 444 9900',
      'orders': 6,
      'totalSpent': 980.00,
      'joined': 'May 2025',
      'color': Color(0xFF8B5CF6),
      'isTop': false,
    },
  ];

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All',     'icon': Icons.people_rounded},
    {'label': 'Top',     'icon': Icons.star_rounded},
    {'label': 'New',     'icon': Icons.fiber_new_rounded},
  ];

  List<Map<String, dynamic>> get _filtered {
    List<Map<String, dynamic>> list = _customers;

    // Apply filter tab
    if (_selectedFilter == 1) {
      list = list.where((c) => c['isTop'] == true).toList();
    } else if (_selectedFilter == 2) {
      list = list.where((c) =>
        (c['joined'] as String).contains('2025') &&
        (c['orders'] as int) <= 5
      ).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
        (c['name'] as String).toLowerCase().contains(q) ||
        (c['email'] as String).toLowerCase().contains(q) ||
        (c['phone'] as String).contains(q)
      ).toList();
    }

    return list;
  }

  // Summary stats
  int get _totalOrders => _customers.fold(
      0, (sum, c) => sum + (c['orders'] as int));
  double get _totalRevenue => _customers.fold(
      0.0, (sum, c) => sum + (c['totalSpent'] as double));
  int get _topCustomers =>
      _customers.where((c) => c['isTop'] == true).length;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
        parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _showCustomerSheet(
      BuildContext context,
      Map<String, dynamic> customer,
      bool isDark,
      Color surfaceColor,
      Color borderColor,
      Color primaryText,
      Color secondaryText) {
    final color = customer['color'] as Color;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(
            16, 0, 16, 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(28),
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

            // Avatar
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 2),
              ),
              child: Center(
                child: Text(
                  (customer['name'] as String)[0]
                      .toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(customer['name'] as String,
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 4),

            Text(customer['email'] as String,
              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            // Stats row
            Row(
              children: [
                _SheetStat(
                  label: 'Orders',
                  value: '${customer['orders']}',
                  color: const Color(0xFF8B5CF6),
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _SheetStat(
                  label: 'Spent',
                  value:
                      'GHS ${(customer['totalSpent'] as double).toStringAsFixed(0)}',
                  color: const Color(0xFF34D399),
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _SheetStat(
                  label: 'Joined',
                  value: customer['joined'] as String,
                  color: const Color(0xFF06B6D4),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Contact buttons
            Row(
              children: [
                Expanded(
                  child: _ContactBtn(
                    icon: Icons.phone_rounded,
                    label: 'Call',
                    color: const Color(0xFF34D399),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ContactBtn(
                    icon: Icons.message_rounded,
                    label: 'Message',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ContactBtn(
                    icon: Icons.receipt_long_rounded,
                    label: 'Orders',
                    color: const Color(0xFF06B6D4),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
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
    final searchHint = isDark
        ? Colors.white.withOpacity(0.3)
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
        title: Text('My Customers',
          style: TextStyle(
            color: primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
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

      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ── STATS ROW ───────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 20, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total',
                        value:
                            '${_customers.length}',
                        icon: Icons.people_rounded,
                        color:
                            const Color(0xFF8B5CF6),
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        label: 'Orders',
                        value: '$_totalOrders',
                        icon: Icons
                            .shopping_bag_rounded,
                        color:
                            const Color(0xFF06B6D4),
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        label: 'Top',
                        value: '$_topCustomers',
                        icon: Icons.star_rounded,
                        color:
                            const Color(0xFFF59E0B),
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── REVENUE BANNER ──────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 14, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4C1D95),
                        Color(0xFF6D28D9),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -20, right: -20,
                        child: Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                                .withOpacity(0.06),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Total Revenue',
                                  style: TextStyle(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                            0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                    height: 4),
                                Text(
                                  'GHS ${_totalRevenue.toStringAsFixed(2)}',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                    letterSpacing:
                                        -0.5,
                                  ),
                                ),
                                const SizedBox(
                                    height: 6),
                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: const Color(
                                            0xFF34D399)
                                        .withOpacity(
                                            0.2),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                  ),
                                  child: const Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [
                                      Icon(
                                        Icons
                                            .trending_up_rounded,
                                        color: Color(
                                            0xFF34D399),
                                        size: 12,
                                      ),
                                      SizedBox(
                                          width: 4),
                                      Text(
                                        'From all customers',
                                        style:
                                            TextStyle(
                                          color: Color(
                                              0xFF34D399),
                                          fontSize:
                                              10,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.all(
                                    14),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(
                                      16),
                            ),
                            child: const Icon(
                              Icons
                                  .attach_money_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── SEARCH BAR ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 16, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius:
                        BorderRadius.circular(14),
                    border:
                        Border.all(color: borderColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(
                        () => _searchQuery = v),
                    style: TextStyle(
                        color: primaryText,
                        fontSize: 14),
                    decoration: InputDecoration(
                      hintText:
                          'Search by name, email or phone...',
                      hintStyle: TextStyle(
                          color: searchHint,
                          fontSize: 13),
                      prefixIcon: Icon(
                          Icons.search_rounded,
                          color: searchHint,
                          size: 20),
                      suffixIcon: _searchQuery
                              .isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController
                                    .clear();
                                setState(() =>
                                    _searchQuery = '');
                              },
                              child: Icon(
                                  Icons
                                      .close_rounded,
                                  color: searchHint,
                                  size: 18),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // ── FILTER CHIPS ─────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 14, 16, 0),
                child: Row(
                  children: List.generate(
                    _filters.length,
                    (i) {
                      final selected =
                          i == _selectedFilter;
                      final f = _filters[i];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback
                              .selectionClick();
                          setState(
                              () => _selectedFilter =
                                  i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                              milliseconds: 200),
                          margin: const EdgeInsets
                              .only(right: 8),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(
                                    0xFF8B5CF6)
                                : surfaceColor,
                            borderRadius:
                                BorderRadius.circular(
                                    20),
                            border: Border.all(
                              color: selected
                                  ? const Color(
                                      0xFF8B5CF6)
                                  : borderColor,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                              0xFF8B5CF6)
                                          .withOpacity(
                                              0.35),
                                      blurRadius: 10,
                                      offset:
                                          const Offset(
                                              0, 3),
                                    )
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                f['icon'] as IconData,
                                size: 14,
                                color: selected
                                    ? Colors.white
                                    : secondaryText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                f['label'] as String,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : secondaryText,
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight
                                          .normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── COUNT LABEL ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 20, 16, 12),
                child: Row(
                  children: [
                    Text(
                      '${_filtered.length} customer${_filtered.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    if (_searchQuery.isNotEmpty)
                      Text(
                        'for "$_searchQuery"',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── CUSTOMER LIST ────────────────────
            _filtered.isEmpty
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: 260,
                      child: Center(
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Container(
                              width: 72, height: 72,
                              decoration: BoxDecoration(
                                color: const Color(
                                        0xFF8B5CF6)
                                    .withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.people_outline_rounded,
                                color: const Color(
                                        0xFF8B5CF6)
                                    .withOpacity(0.5),
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No customers found',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try a different search\nor filter',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding:
                        const EdgeInsets.fromLTRB(
                            16, 0, 16, 100),
                    sliver: SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (context, index) {
                          final customer =
                              _filtered[index];
                          final color = customer[
                              'color'] as Color;
                          final isTop = customer[
                                  'isTop'] as bool;
                          final initials =
                              (customer['name']
                                      as String)
                                  .split(' ')
                                  .map((p) => p[0])
                                  .take(2)
                                  .join()
                                  .toUpperCase();

                          return GestureDetector(
                            onTap: () =>
                                _showCustomerSheet(
                              context,
                              customer,
                              isDark,
                              surfaceColor,
                              borderColor,
                              primaryText,
                              secondaryText,
                            ),
                            child: Container(
                              margin:
                                  const EdgeInsets
                                      .only(
                                      bottom: 12),
                              decoration:
                                  BoxDecoration(
                                color: surfaceColor,
                                borderRadius:
                                    BorderRadius
                                        .circular(20),
                                border: Border.all(
                                    color:
                                        borderColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: color
                                        .withOpacity(
                                            0.06),
                                    blurRadius: 12,
                                    offset:
                                        const Offset(
                                            0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets
                                        .all(16),
                                child: Row(
                                  children: [

                                    // Avatar
                                    Stack(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration:
                                              BoxDecoration(
                                            color: color
                                                .withOpacity(
                                                    0.15),
                                            shape:
                                                BoxShape
                                                    .circle,
                                            border:
                                                Border.all(
                                              color: color
                                                  .withOpacity(
                                                      0.3),
                                              width:
                                                  1.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              initials,
                                              style:
                                                  TextStyle(
                                                color:
                                                    color,
                                                fontSize:
                                                    16,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Top badge
                                        if (isTop)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child:
                                                Container(
                                              width:
                                                  18,
                                              height:
                                                  18,
                                              decoration:
                                                  const BoxDecoration(
                                                color: Color(
                                                    0xFFF59E0B),
                                                shape:
                                                    BoxShape
                                                        .circle,
                                              ),
                                              child: const Icon(
                                                Icons
                                                    .star_rounded,
                                                color:
                                                    Colors.white,
                                                size:
                                                    11,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(
                                        width: 14),

                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    Text(
                                                  customer[
                                                      'name'] as String,
                                                  style:
                                                      TextStyle(
                                                    color:
                                                        primaryText,
                                                    fontSize:
                                                        15,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                    letterSpacing:
                                                        -0.2,
                                                  ),
                                                ),
                                              ),
                                              // Orders badge
                                              Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                  horizontal:
                                                      8,
                                                  vertical:
                                                      3,
                                                ),
                                                decoration:
                                                    BoxDecoration(
                                                  color:
                                                      color.withOpacity(
                                                          0.1),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              20),
                                                ),
                                                child:
                                                    Text(
                                                  '${customer['orders']} orders',
                                                  style:
                                                      TextStyle(
                                                    color:
                                                        color,
                                                    fontSize:
                                                        10,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  3),
                                          Text(
                                            customer[
                                                'email'] as String,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                TextStyle(
                                              color:
                                                  secondaryText,
                                              fontSize:
                                                  12,
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                                  6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .attach_money_rounded,
                                                size:
                                                    13,
                                                color:
                                                    const Color(
                                                        0xFF34D399),
                                              ),
                                              Text(
                                                'GHS ${(customer['totalSpent'] as double).toStringAsFixed(0)}',
                                                style:
                                                    const TextStyle(
                                                  color: Color(
                                                      0xFF34D399),
                                                  fontSize:
                                                      12,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10),
                                              Icon(
                                                Icons
                                                    .calendar_today_rounded,
                                                size:
                                                    11,
                                                color:
                                                    secondaryText,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      3),
                                              Text(
                                                customer[
                                                    'joined'] as String,
                                                style:
                                                    TextStyle(
                                                  color:
                                                      secondaryText,
                                                  fontSize:
                                                      11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 8),

                                    Icon(
                                      Icons
                                          .arrow_forward_ios_rounded,
                                      color:
                                          secondaryText,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: _filtered.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),

      // ── FAB ────────────────────────────────────
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C3AED),
              Color(0xFF8B5CF6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6)
                  .withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: isDark
                      ? const Color(0xFF1E1B2E)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14)),
                  margin: const EdgeInsets.all(16),
                  content: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(
                                  0xFF8B5CF6)
                              .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(
                                  10),
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add customer coming soon',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(
                                  0xFF0F172A),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                Icons.person_add_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(height: 10),
          Text(value,
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet stat ────────────────────────────────────────────────────────────────
class _SheetStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _SheetStat({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(label,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.45)
                    : const Color(0xFF64748B),
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

// ── Contact button ────────────────────────────────────────────────────────────
class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 5),
            Text(label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:comfi/consts/theme_toggle_button.dart';
import 'package:flutter/material.dart';

class SellersStatisticsScreen extends StatefulWidget {
  const SellersStatisticsScreen({super.key});

  @override
  State<SellersStatisticsScreen> createState() =>
      _SellersStatisticsScreenState();
}

class _SellersStatisticsScreenState
    extends State<SellersStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  String _selectedPeriod = 'This Month';
  final List<String> _periods = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  final List<Map<String, dynamic>> _weeklyRevenue = [
    {'day': 'Mon', 'amount': 320.0},
    {'day': 'Tue', 'amount': 540.0},
    {'day': 'Wed', 'amount': 290.0},
    {'day': 'Thu', 'amount': 780.0},
    {'day': 'Fri', 'amount': 620.0},
    {'day': 'Sat', 'amount': 940.0},
    {'day': 'Sun', 'amount': 410.0},
  ];

  final List<Map<String, dynamic>> _topProducts = [
    {
      'name': 'Wireless Earbuds',
      'sold': 34,
      'revenue': 'GHS 2,380',
      'change': '+12%',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Phone Case',
      'sold': 28,
      'revenue': 'GHS 840',
      'change': '+8%',
      'color': const Color(0xFF06B6D4),
    },
    {
      'name': 'USB-C Charger',
      'sold': 21,
      'revenue': 'GHS 630',
      'change': '-3%',
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'Screen Protector',
      'sold': 19,
      'revenue': 'GHS 380',
      'change': '+5%',
      'color': const Color(0xFF34D399),
    },
  ];

  final List<Map<String, dynamic>> _orderStatus = [
    {'label': 'Delivered', 'count': 14, 'color': const Color(0xFF34D399)},
    {'label': 'Pending', 'count': 6, 'color': const Color(0xFFF59E0B)},
    {'label': 'Packaging', 'count': 4, 'color': const Color(0xFF06B6D4)},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double get _maxRevenue => _weeklyRevenue
      .map((e) => e['amount'] as double)
      .reduce((a, b) => a > b ? a : b);

  int get _totalOrders =>
      _orderStatus.fold(0, (sum, e) => sum + (e['count'] as int));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Responsive scale ──────────────────────────────
    // Base design width is 390 (iPhone 14). Scale clamps so
    // small phones shrink gracefully and tablets enlarge moderately.
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = (screenWidth / 390).clamp(0.8, 1.3);
    final sidePad = (screenWidth * 0.04).clamp(12.0, 24.0);

    // ── Theme tokens ──────────────────────────────────
    final scaffoldBg =
        isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: borderColor)),
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
        title: Text(
          'Statistics',
          style: TextStyle(
            color: primaryText,
            fontSize: 20 * scale,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 16, top: 8, bottom: 8),
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
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Period selector ─────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 20, sidePad, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _periods.map((period) {
                        final selected = period == _selectedPeriod;
                        return GestureDetector(
                          onTap: () => setState(
                              () => _selectedPeriod = period),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14 * scale,
                              vertical: 8 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF8B5CF6)
                                  : surfaceColor,
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF8B5CF6)
                                    : borderColor,
                              ),
                            ),
                            child: Text(
                              period,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : secondaryText,
                                fontSize: 13 * scale,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // ── KPI row ─────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 20, sidePad, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _KpiCard(
                          label: 'Revenue',
                          value: 'GHS\n3,900',
                          change: '+18%',
                          positive: true,
                          icon: Icons.attach_money_rounded,
                          color: const Color(0xFF34D399),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          scale: scale,
                        ),
                      ),
                      SizedBox(width: 10 * scale),
                      Expanded(
                        child: _KpiCard(
                          label: 'Orders',
                          value: '24',
                          change: '+3',
                          positive: true,
                          icon: Icons.shopping_bag_rounded,
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          scale: scale,
                        ),
                      ),
                      SizedBox(width: 10 * scale),
                      Expanded(
                        child: _KpiCard(
                          label: 'Customers',
                          value: '18',
                          change: '+2',
                          positive: true,
                          icon: Icons.people_rounded,
                          color: const Color(0xFF06B6D4),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          scale: scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Revenue chart ────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 24, sidePad, 0),
                  child: _SectionLabel(
                    label: 'Revenue this week',
                    primaryText: primaryText,
                    scale: scale,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 14, sidePad, 0),
                  child: Container(
                    padding: EdgeInsets.all(18 * scale),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(isDark ? 0.06 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GHS 3,900.00',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 22 * scale,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8 * scale,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF34D399)
                                .withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                color: const Color(0xFF34D399),
                                size: 12 * scale,
                              ),
                              SizedBox(width: 4 * scale),
                              Text(
                                '+18% vs last week',
                                style: TextStyle(
                                  color:
                                      const Color(0xFF34D399),
                                  fontSize: 11 * scale,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20 * scale),
                        // ✅ Overflow-safe chart widget
                        _BarChart(
                          data: _weeklyRevenue,
                          maxValue: _maxRevenue,
                          isDark: isDark,
                          secondaryText: secondaryText,
                          scale: scale,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Order breakdown ──────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 24, sidePad, 0),
                  child: _SectionLabel(
                    label: 'Order breakdown',
                    primaryText: primaryText,
                    scale: scale,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 14, sidePad, 0),
                  child: Container(
                    padding: EdgeInsets.all(18 * scale),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(isDark ? 0.06 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _orderStatus.map((item) {
                        final pct = (item['count'] as int) /
                            _totalOrders;
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 14 * scale),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration:
                                            BoxDecoration(
                                          color: item['color']
                                              as Color,
                                          borderRadius:
                                              BorderRadius
                                                  .circular(3),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 8),
                                      Text(
                                        item['label']
                                            as String,
                                        style: TextStyle(
                                          color: primaryText,
                                          fontSize:
                                              13 * scale,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${item['count']} orders'
                                    ' (${(pct * 100).toStringAsFixed(0)}%)',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12 * scale,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(6),
                                child:
                                    LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 8,
                                  backgroundColor:
                                      (item['color'] as Color)
                                          .withOpacity(0.1),
                                  valueColor:
                                      AlwaysStoppedAnimation<
                                          Color>(
                                    item['color'] as Color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // ── Top products ─────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(sidePad, 24, sidePad, 0),
                  child: _SectionLabel(
                    label: 'Top products',
                    primaryText: primaryText,
                    scale: scale,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    sidePad, 14, sidePad, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _topProducts[index];
                      final isPositive =
                          (product['change'] as String)
                              .startsWith('+');
                      final changeColor = isPositive
                          ? const Color(0xFF34D399)
                          : const Color(0xFFE83A8A);

                      return Container(
                        margin: EdgeInsets.only(
                            bottom: 10 * scale),
                        padding: EdgeInsets.all(16 * scale),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius:
                              BorderRadius.circular(18),
                          border:
                              Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (product['color'] as Color)
                                      .withOpacity(
                                          isDark ? 0.06 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34 * scale,
                              height: 34 * scale,
                              decoration: BoxDecoration(
                                color:
                                    (product['color'] as Color)
                                        .withOpacity(0.12),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '#${index + 1}',
                                  style: TextStyle(
                                    color: product['color']
                                        as Color,
                                    fontSize: 12 * scale,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12 * scale),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] as String,
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: 14 * scale,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 3 * scale),
                                  Text(
                                    '${product['sold']} sold'
                                    ' · ${product['revenue']}',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12 * scale,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10 * scale,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: changeColor
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons
                                            .trending_up_rounded
                                        : Icons
                                            .trending_down_rounded,
                                    color: changeColor,
                                    size: 12 * scale,
                                  ),
                                  SizedBox(width: 4 * scale),
                                  Text(
                                    product['change']
                                        as String,
                                    style: TextStyle(
                                      color: changeColor,
                                      fontSize: 12 * scale,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: _topProducts.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color primaryText;
  final double scale;

  const _SectionLabel({
    required this.label,
    required this.primaryText,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: primaryText,
        fontSize: 18 * scale,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
  }
}

// ── KPI card ──────────────────────────────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool positive;
  final IconData icon;
  final Color color;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final double scale;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.change,
    required this.positive,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor =
        positive ? const Color(0xFF34D399) : const Color(0xFFE83A8A);
    final iconBoxSize = (34 * scale).clamp(28.0, 44.0);

    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.08 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color,
                size: (18 * scale).clamp(14.0, 22.0)),
          ),
          SizedBox(height: 8 * scale),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: (14 * scale).clamp(11.0, 18.0),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          SizedBox(height: 2 * scale),
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.4)
                  : const Color(0xFF94A3B8),
              fontSize: (11 * scale).clamp(9.0, 14.0),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4 * scale),
          Text(
            change,
            style: TextStyle(
              color: changeColor,
              fontSize: (11 * scale).clamp(9.0, 14.0),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bar chart — overflow-safe ──────────────────────────────────────────────────
//
// THE FIX explained:
//
// Previously the chart used a SizedBox(height: 140) that contained both
// the bars AND the floating peak label. The label sat inside the same
// height budget as the bars, so when Flutter tried to draw everything
// it overflowed by the label's height (~16 px).
//
// Now the chart column has THREE explicit, non-overlapping rows:
//   1. peakLabelHeight  — reserved space for the "GHS 940" bubble
//                         (empty SizedBox for non-peak bars, so all
//                          columns stay the same total height)
//   2. barAreaHeight    — the actual bar, drawn proportionally
//   3. dayLabelHeight   — the "Mon", "Tue"... text
//
// Total SizedBox height = sum of those three, so nothing ever overflows.
//
class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final bool isDark;
  final Color secondaryText;
  final double scale;

  const _BarChart({
    required this.data,
    required this.maxValue,
    required this.isDark,
    required this.secondaryText,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final barAreaHeight  = 100.0 * scale;  // bars only
    final dayLabelHeight = 20.0 * scale;   // day text row
    final peakLabelHeight = 22.0 * scale;  // "GHS 940" row

    return SizedBox(
      height: peakLabelHeight + barAreaHeight + dayLabelHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final amount    = item['amount'] as double;
          final ratio     = amount / maxValue;
          final isHighest = amount == maxValue;
          final barHeight = barAreaHeight * ratio;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (4 * scale).clamp(2.0, 6.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Row 1 — peak label (same height for every column)
                  SizedBox(
                    height: peakLabelHeight,
                    child: isHighest
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: EdgeInsets.symmetric(
                                horizontal: 5 * scale,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: Text(
                                'GHS ${amount.toInt()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      (9 * scale).clamp(8.0, 12.0),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Row 2 — bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    height: barHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isHighest
                            ? const [
                                Color(0xFF8B5CF6),
                                Color(0xFF6D28D9),
                              ]
                            : [
                                const Color(0xFF8B5CF6)
                                    .withOpacity(isDark ? 0.5 : 0.35),
                                const Color(0xFF8B5CF6)
                                    .withOpacity(isDark ? 0.3 : 0.2),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(
                          (8 * scale).clamp(4.0, 12.0)),
                    ),
                  ),

                  // Row 3 — day label
                  SizedBox(
                    height: dayLabelHeight,
                    child: Center(
                      child: Text(
                        item['day'] as String,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize:
                              (11 * scale).clamp(9.0, 14.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
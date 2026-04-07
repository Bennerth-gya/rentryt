import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SellersRevenueScreen
//
//  A full revenue analytics screen for Comfi sellers. Sections:
//
//   • Hero header      — period selector + live total with growth badge
//   • Line sparkline   — custom-painted 7-point revenue curve
//   • KPI strip        — Gross / Net / Fees / Refunds
//   • Revenue sources  — per-channel breakdown with progress bars
//   • Daily breakdown  — scrollable day-by-day table with trend arrows
//   • Monthly summary  — last 6 months comparison cards
//   • Withdraw CTA     — sticky bottom bar
//
//  All data is mock — replace with your repository/ViewModel calls.
// ─────────────────────────────────────────────────────────────────────────────

class SellersRevenueScreen extends StatefulWidget {
  const SellersRevenueScreen({super.key});

  @override
  State<SellersRevenueScreen> createState() => _SellersRevenueScreenState();
}

class _SellersRevenueScreenState extends State<SellersRevenueScreen>
    with TickerProviderStateMixin {
  // ── Animation ──────────────────────────────────────────────────────────────
  late AnimationController _pageCtrl;
  late Animation<double> _pageFade;
  late Animation<Offset> _pageSlide;

  late AnimationController _sparklineCtrl;
  late Animation<double> _sparklineAnim;

  // ── Period ─────────────────────────────────────────────────────────────────
  int _period = 1; // 0=Today 1=Week 2=Month 3=Year
  static const _periodLabels = ['Today', 'Week', 'Month', 'Year'];

  // ── Mock data ──────────────────────────────────────────────────────────────

  // Sparkline points per period (7 values, normalised 0-1 by painter)
  static const _sparkData = {
    0: [0.4, 0.6, 0.3, 0.8, 0.5, 0.9, 0.7],
    1: [0.3, 0.5, 0.4, 0.7, 0.6, 1.0, 0.8],
    2: [0.5, 0.4, 0.6, 0.8, 0.7, 0.9, 1.0],
    3: [0.2, 0.4, 0.5, 0.6, 0.7, 0.85, 1.0],
  };

  static const _sparkLabels = {
    0: ['12a', '4a', '8a', '12p', '4p', '8p', '11p'],
    1: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    2: ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'],
    3: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
  };

  static const _grossRevenue = {
    0: 1260.40,
    1: 5650.00,
    2: 31600.00,
    3: 253000.00,
  };

  static const _netRevenue = {
    0: 1134.36,
    1: 5085.00,
    2: 28440.00,
    3: 227700.00,
  };

  static const _feesAmount = {
    0: 63.02,
    1: 282.50,
    2: 1580.00,
    3: 12650.00,
  };

  static const _refundsAmount = {
    0: 63.02,
    1: 282.50,
    2: 1580.00,
    3: 12650.00,
  };

  static const _growthPct = {0: 12.0, 1: 8.0, 2: 21.0, 3: 34.0};

  // Revenue sources
  final List<_RevenueSource> _sources = const [
    _RevenueSource(
      label: 'Direct Sales',
      amount: 3820.00,
      fraction: 0.68,
      color: Color(0xFF8B5CF6),
      icon: Icons.storefront_rounded,
    ),
    _RevenueSource(
      label: 'Promoted Listings',
      amount: 1130.00,
      fraction: 0.20,
      color: Color(0xFF06B6D4),
      icon: Icons.campaign_rounded,
    ),
    _RevenueSource(
      label: 'Bundle Deals',
      amount: 480.00,
      fraction: 0.08,
      color: Color(0xFF34D399),
      icon: Icons.category_rounded,
    ),
    _RevenueSource(
      label: 'Flash Sales',
      amount: 220.00,
      fraction: 0.04,
      color: Color(0xFFF59E0B),
      icon: Icons.bolt_rounded,
    ),
  ];

  // Daily breakdown (last 7 days)
  final List<_DayRevenue> _daily = const [
    _DayRevenue(day: 'Today',     amount: 1260.40, orders: 8,  trend: 0.12),
    _DayRevenue(day: 'Yesterday', amount: 1125.00, orders: 7,  trend: -0.04),
    _DayRevenue(day: 'Mon',       amount: 980.00,  orders: 6,  trend: 0.08),
    _DayRevenue(day: 'Sun',       amount: 1400.00, orders: 10, trend: 0.22),
    _DayRevenue(day: 'Sat',       amount: 1840.00, orders: 13, trend: 0.31),
    _DayRevenue(day: 'Fri',       amount: 1320.00, orders: 9,  trend: 0.05),
    _DayRevenue(day: 'Thu',       amount: 890.00,  orders: 6,  trend: -0.09),
  ];

  // Monthly summary (last 6 months)
  final List<_MonthSummary> _months = const [
    _MonthSummary(month: 'Jul', amount: 31600, growth: 0.21),
    _MonthSummary(month: 'Jun', amount: 26100, growth: 0.14),
    _MonthSummary(month: 'May', amount: 22900, growth: 0.09),
    _MonthSummary(month: 'Apr', amount: 21000, growth: -0.03),
    _MonthSummary(month: 'Mar', amount: 21600, growth: 0.07),
    _MonthSummary(month: 'Feb', amount: 20200, growth: 0.12),
  ];

  @override
  void initState() {
    super.initState();

    _pageCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _pageFade =
        CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut));

    _sparklineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _sparklineAnim = CurvedAnimation(
        parent: _sparklineCtrl, curve: Curves.easeOutCubic);

    _pageCtrl.forward();
    _sparklineCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _sparklineCtrl.dispose();
    super.dispose();
  }

  void _changePeriod(int p) {
    if (p == _period) return;
    HapticFeedback.lightImpact();
    _sparklineCtrl.reset();
    setState(() => _period = p);
    _sparklineCtrl.forward();
  }

  // ── Formatters ─────────────────────────────────────────────────────────────
  String _fmt(double v) {
    if (v >= 1000) {
      return 'GHS ${(v / 1000).toStringAsFixed(1)}k';
    }
    return 'GHS ${v.toStringAsFixed(2)}';
  }

  String _fmtFull(double v) =>
      'GHS ${v.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},')}';

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      body: FadeTransition(
        opacity: _pageFade,
        child: SlideTransition(
          position: _pageSlide,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── HERO ──────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildHero(isDark),
              ),

              // ── SPARKLINE ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildSparkline(
                    isDark, surfaceColor, borderColor,
                    primaryText, secondaryText),
              ),

              // ── KPI STRIP ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildKpiStrip(
                    isDark, surfaceColor, borderColor,
                    primaryText, secondaryText),
              ),

              // ── REVENUE SOURCES ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildRevenueSources(
                    isDark, surfaceColor, borderColor,
                    primaryText, secondaryText),
              ),

              // ── DAILY BREAKDOWN ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildDailyBreakdown(
                    isDark, surfaceColor, borderColor,
                    primaryText, secondaryText),
              ),

              // ── MONTHLY SUMMARY ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildMonthlySummary(
                    isDark, surfaceColor, borderColor,
                    primaryText, secondaryText),
              ),

              // Bottom padding for the sticky bar
              const SliverToBoxAdapter(
                  child: SizedBox(height: 110)),
            ],
          ),
        ),
      ),

      // ── STICKY WITHDRAW BAR ───────────────────────────────────────────────
      bottomNavigationBar: _buildWithdrawBar(
          isDark, surfaceColor, borderColor),
    );
  }

  // ── HERO HEADER ────────────────────────────────────────────────────────────
  Widget _buildHero(bool isDark) {
    final gross = _grossRevenue[_period]!;
    final growth = _growthPct[_period]!;
    final isPositive = growth >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064E3B),
            Color(0xFF065F46),
            Color(0xFF047857),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -30, right: -20,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -30, left: -40,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row — back + title + export
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const Text('Revenue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download_rounded,
                              color: Colors.white, size: 14),
                          SizedBox(width: 5),
                          Text('Export',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Revenue label
              Text('Gross Revenue',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),

              // Big number
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _fmtFull(gross),
                  key: ValueKey(gross),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    height: 1.1,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Growth badge + comparison label
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isPositive
                              ? const Color(0xFF34D399)
                              : const Color(0xFFEF4444))
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: isPositive
                              ? const Color(0xFF34D399)
                              : const Color(0xFFEF4444),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isPositive ? '+' : ''}${growth.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: isPositive
                                ? const Color(0xFF34D399)
                                : const Color(0xFFEF4444),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'vs previous ${_periodLabels[_period].toLowerCase()}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Period selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  children: List.generate(_periodLabels.length, (i) {
                    final selected = i == _period;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _changePeriod(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          padding:
                              const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _periodLabels[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.45),
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── SPARKLINE ──────────────────────────────────────────────────────────────
  Widget _buildSparkline(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    final data = _sparkData[_period]!;
    final labels = _sparkLabels[_period]!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Revenue Trend',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34D399).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_periodLabels[_period],
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Custom sparkline painter
            AnimatedBuilder(
              animation: _sparklineAnim,
              builder: (_, __) => CustomPaint(
                size: const Size(double.infinity, 100),
                painter: _SparklinePainter(
                  data: data,
                  progress: _sparklineAnim.value,
                  isDark: isDark,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // X-axis labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((l) => Text(l,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withOpacity(0.3)
                      : const Color(0xFF94A3B8),
                  fontSize: 10,
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── KPI STRIP ──────────────────────────────────────────────────────────────
  Widget _buildKpiStrip(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    final kpis = [
      _KpiData(
        label: 'Gross',
        value: _fmt(_grossRevenue[_period]!),
        icon: Icons.attach_money_rounded,
        color: const Color(0xFF34D399),
        sub: 'Total earned',
      ),
      _KpiData(
        label: 'Net',
        value: _fmt(_netRevenue[_period]!),
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFF8B5CF6),
        sub: 'After fees',
      ),
      _KpiData(
        label: 'Fees',
        value: _fmt(_feesAmount[_period]!),
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFFF59E0B),
        sub: '5% platform',
      ),
      _KpiData(
        label: 'Refunds',
        value: _fmt(_refundsAmount[_period]!),
        icon: Icons.undo_rounded,
        color: const Color(0xFFEF4444),
        sub: 'Returned',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.7,
        children: kpis.map((k) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: k.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(k.icon, color: k.color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(k.value,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(k.label,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(k.sub,
                        style: TextStyle(
                          color: k.color,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── REVENUE SOURCES ────────────────────────────────────────────────────────
  Widget _buildRevenueSources(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Revenue Sources',
            subtitle: 'Where your money comes from',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: _sources.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34, height: 34,
                            decoration: BoxDecoration(
                              color: s.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(s.icon, color: s.color, size: 17),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(s.label,
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_fmtFull(s.amount),
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${(s.fraction * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: s.color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: s.fraction,
                          minHeight: 7,
                          backgroundColor: s.color.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(s.color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── DAILY BREAKDOWN ────────────────────────────────────────────────────────
  Widget _buildDailyBreakdown(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Daily Breakdown',
            subtitle: 'Last 7 days',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: List.generate(_daily.length, (i) {
                final d = _daily[i];
                final isLast = i == _daily.length - 1;
                final isPositive = d.trend >= 0;
                final trendColor = isPositive
                    ? const Color(0xFF34D399)
                    : const Color(0xFFEF4444);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          // Day label
                          SizedBox(
                            width: 72,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(d.day,
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text('${d.orders} orders',
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Mini bar
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: d.amount / 1840,
                                  minHeight: 6,
                                  backgroundColor:
                                      const Color(0xFF8B5CF6)
                                          .withOpacity(0.08),
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                          Color(0xFF8B5CF6)),
                                ),
                              ),
                            ),
                          ),

                          // Amount + trend
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_fmtFull(d.amount),
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons.arrow_drop_up_rounded
                                        : Icons.arrow_drop_down_rounded,
                                    color: trendColor,
                                    size: 16,
                                  ),
                                  Text(
                                    '${isPositive ? '+' : ''}${(d.trend * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: trendColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFE2E8F0),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── MONTHLY SUMMARY ────────────────────────────────────────────────────────
  Widget _buildMonthlySummary(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    final maxAmount =
        _months.map((m) => m.amount).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Monthly Summary',
            subtitle: 'Last 6 months comparison',
            primaryText: primaryText,
            secondaryText: secondaryText,
          ),
          const SizedBox(height: 14),

          // Horizontal scroll of month cards
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _months.length,
              padding: EdgeInsets.zero,
              itemBuilder: (_, i) {
                final m = _months[i];
                final isFirst = i == 0; // most recent
                final fraction = m.amount / maxAmount;
                final isPositive = m.growth >= 0;
                final growthColor = isPositive
                    ? const Color(0xFF34D399)
                    : const Color(0xFFEF4444);

                return Container(
                  width: 110,
                  margin: EdgeInsets.only(
                      right: i == _months.length - 1 ? 0 : 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isFirst
                        ? const Color(0xFF34D399).withOpacity(0.08)
                        : surfaceColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isFirst
                          ? const Color(0xFF34D399).withOpacity(0.35)
                          : borderColor,
                      width: isFirst ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Month + badge
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.month,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isFirst)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF34D399)
                                    .withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: const Text('Now',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Mini bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: fraction,
                          minHeight: 5,
                          backgroundColor:
                              const Color(0xFF34D399).withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(
                            isFirst
                                ? const Color(0xFF34D399)
                                : const Color(0xFF34D399)
                                    .withOpacity(0.4),
                          ),
                        ),
                      ),

                      // Amount
                      Text(
                        'GHS ${(m.amount / 1000).toStringAsFixed(1)}k',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),

                      // Growth
                      Row(
                        children: [
                          Icon(
                            isPositive
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: growthColor,
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${isPositive ? '+' : ''}${(m.growth * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: growthColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── STICKY WITHDRAW BAR ────────────────────────────────────────────────────
  Widget _buildWithdrawBar(
      bool isDark, Color surfaceColor, Color borderColor) {
    final net = _netRevenue[_period]!;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : const Color(0xFF34D399).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Available to withdraw',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withOpacity(0.45)
                        : const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(_fmtFull(840.40),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showWithdrawSheet(isDark),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF047857)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34D399).withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Withdraw',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── WITHDRAW BOTTOM SHEET ──────────────────────────────────────────────────
  void _showWithdrawSheet(bool isDark) {
    final sheetBg =
        isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 20, right: 20, top: 20,
        ),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.2)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text('Withdraw Funds',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Available: GHS 840.40',
              style: TextStyle(
                color: Color(0xFF34D399),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Amount field
            Text('Amount (GHS)',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1F2937)
                    : const Color(0xFFEEF1FB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFFADB5C7)),
                  prefixIcon: const Icon(
                      Icons.currency_exchange_rounded,
                      color: Color(0xFF34D399), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Method selector
            Text('To',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1F2937)
                    : const Color(0xFFEEF1FB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.phone_android_rounded,
                        color: Color(0xFFF59E0B), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MTN Mobile Money',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('024 **** 5678',
                          style: TextStyle(
                              color: secondaryText, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      color: secondaryText, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Confirm Withdrawal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Custom sparkline painter
// ─────────────────────────────────────────────────────────────────────────────
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final double progress; // 0.0 → 1.0 animation progress
  final bool isDark;

  _SparklinePainter({
    required this.data,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal).clamp(0.01, double.infinity);

    // Map data points to canvas coordinates
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalised = (data[i] - minVal) / range;
      final y = size.height - (normalised * size.height * 0.85) - 8;
      points.add(Offset(x, y));
    }

    // Clip to progress (animate left-to-right)
    final clipWidth = size.width * progress;
    canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, size.height));

    // Build smooth cubic bezier path
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1 = Offset(
        points[i].dx + (points[i + 1].dx - points[i].dx) * 0.5,
        points[i].dy,
      );
      final cp2 = Offset(
        points[i].dx + (points[i + 1].dx - points[i].dx) * 0.5,
        points[i + 1].dy,
      );
      linePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy,
          points[i + 1].dx, points[i + 1].dy);
    }

    // Gradient fill under the line
    final fillPath = Path.from(linePath);
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.lineTo(points.first.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF34D399).withOpacity(isDark ? 0.25 : 0.18),
          const Color(0xFF34D399).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Line stroke
    final linePaint = Paint()
      ..color = const Color(0xFF34D399)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // Peak dot
    final peakIndex =
        data.indexOf(data.reduce((a, b) => a > b ? a : b));
    final peakPoint = points[peakIndex];

    if (peakPoint.dx <= clipWidth) {
      // Outer glow
      canvas.drawCircle(
        peakPoint,
        8,
        Paint()
          ..color = const Color(0xFF34D399).withOpacity(0.25)
          ..style = PaintingStyle.fill,
      );
      // White core
      canvas.drawCircle(
        peakPoint,
        4.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
      // Green border
      canvas.drawCircle(
        peakPoint,
        4.5,
        Paint()
          ..color = const Color(0xFF34D399)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.progress != progress ||
      old.data != data ||
      old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Reusable section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color primaryText;
  final Color secondaryText;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: TextStyle(
                color: primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text(subtitle,
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Data models (move to your models/ folder and replace with real data)
// ─────────────────────────────────────────────────────────────────────────────

class _RevenueSource {
  final String label;
  final double amount;
  final double fraction; // 0.0–1.0
  final Color color;
  final IconData icon;

  const _RevenueSource({
    required this.label,
    required this.amount,
    required this.fraction,
    required this.color,
    required this.icon,
  });
}

class _DayRevenue {
  final String day;
  final double amount;
  final int orders;
  final double trend; // signed fraction e.g. 0.12 = +12%

  const _DayRevenue({
    required this.day,
    required this.amount,
    required this.orders,
    required this.trend,
  });
}

class _MonthSummary {
  final String month;
  final double amount;
  final double growth; // signed fraction

  const _MonthSummary({
    required this.month,
    required this.amount,
    required this.growth,
  });
}

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;

  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.sub,
  });
}
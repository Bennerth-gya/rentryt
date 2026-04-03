import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellerEarningsScreen extends StatefulWidget {
  const SellerEarningsScreen({super.key});

  @override
  State<SellerEarningsScreen> createState() =>
      _SellerEarningsScreenState();
}

class _SellerEarningsScreenState extends State<SellerEarningsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _selectedPeriod = 1; // 0=Today, 1=Week, 2=Month, 3=Year
  int _selectedTab = 0;    // 0=Overview, 1=Transactions, 2=Payouts

  final List<String> _periods = ['Today', 'Week', 'Month', 'Year'];

  // Mock bar chart data per period
  final Map<int, List<double>> _chartData = {
    0: [120, 80, 200, 150, 90, 310, 180],
    1: [640, 820, 540, 910, 760, 1100, 880],
    2: [3200, 4100, 2900, 5200, 4700, 6100, 5400],
    3: [28000, 34000, 29000, 41000, 37000, 45000, 39000],
  };

  final Map<int, List<String>> _chartLabels = {
    0: ['12a', '4a', '8a', '12p', '4p', '8p', '11p'],
    1: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    2: ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'],
    3: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
  };

  final Map<int, String> _totalRevenue = {
    0: '1,260.40',
    1: '5,650.00',
    2: '31,600.00',
    3: '253,000.00',
  };

  final Map<int, String> _growth = {
    0: '+12%',
    1: '+8%',
    2: '+21%',
    3: '+34%',
  };

  final List<Map<String, dynamic>> _transactions = [
    {
      'name': 'Akosua Mensah',
      'item': 'Electric Kettle',
      'amount': '+GHS 240.00',
      'time': '2 hrs ago',
      'status': 'completed',
      'avatar': 'A',
      'color': Color(0xFF8B5CF6),
    },
    {
      'name': 'Kwame Boateng',
      'item': 'Laptop Stand',
      'amount': '+GHS 180.00',
      'time': '5 hrs ago',
      'status': 'completed',
      'avatar': 'K',
      'color': Color(0xFF06B6D4),
    },
    {
      'name': 'Esi Amponsah',
      'item': 'Wireless Mouse',
      'amount': '+GHS 95.00',
      'time': 'Yesterday',
      'status': 'completed',
      'avatar': 'E',
      'color': Color(0xFF34D399),
    },
    {
      'name': 'Yaw Darko',
      'item': 'Phone Case × 2',
      'amount': '+GHS 60.00',
      'time': 'Yesterday',
      'status': 'pending',
      'avatar': 'Y',
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'Abena Osei',
      'item': 'USB-C Hub',
      'amount': '+GHS 320.00',
      'time': '2 days ago',
      'status': 'completed',
      'avatar': 'A',
      'color': Color(0xFFE83A8A),
    },
    {
      'name': 'Kofi Asante',
      'item': 'Bluetooth Speaker',
      'amount': '-GHS 50.00',
      'time': '3 days ago',
      'status': 'refunded',
      'avatar': 'K',
      'color': Color(0xFF94A3B8),
    },
    {
      'name': 'Adwoa Frimpong',
      'item': 'Desk Lamp',
      'amount': '+GHS 115.00',
      'time': '4 days ago',
      'status': 'completed',
      'avatar': 'A',
      'color': Color(0xFF8B5CF6),
    },
  ];

  final List<Map<String, dynamic>> _payouts = [
    {
      'id': '#PAY-20241201',
      'amount': 'GHS 3,200.00',
      'date': 'Dec 1, 2024',
      'method': 'MTN MoMo',
      'status': 'paid',
    },
    {
      'id': '#PAY-20241115',
      'amount': 'GHS 2,850.00',
      'date': 'Nov 15, 2024',
      'method': 'MTN MoMo',
      'status': 'paid',
    },
    {
      'id': '#PAY-20241101',
      'amount': 'GHS 4,100.00',
      'date': 'Nov 1, 2024',
      'method': 'Bank Transfer',
      'status': 'paid',
    },
    {
      'id': '#PAY-20241015',
      'amount': 'GHS 1,920.00',
      'date': 'Oct 15, 2024',
      'method': 'MTN MoMo',
      'status': 'processing',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

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
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── HERO HEADER ──────────────────────────
              SliverToBoxAdapter(
                child: _buildHeroHeader(isDark, surfaceColor, borderColor),
              ),

              // ── PERIOD SELECTOR ──────────────────────
              SliverToBoxAdapter(
                child: _buildPeriodSelector(isDark, surfaceColor, borderColor),
              ),

              // ── CHART ────────────────────────────────
              SliverToBoxAdapter(
                child: _buildChart(isDark, surfaceColor, borderColor),
              ),

              // ── MINI STATS ROW ───────────────────────
              SliverToBoxAdapter(
                child: _buildMiniStats(isDark, surfaceColor, borderColor, primaryText, secondaryText),
              ),

              // ── BALANCE CARD ─────────────────────────
              SliverToBoxAdapter(
                child: _buildBalanceCard(isDark, surfaceColor, borderColor, primaryText, secondaryText),
              ),

              // ── TAB BAR ──────────────────────────────
              SliverToBoxAdapter(
                child: _buildTabBar(isDark, surfaceColor, borderColor, primaryText),
              ),

              // ── TAB CONTENT ──────────────────────────
              SliverToBoxAdapter(
                child: _selectedTab == 0
                    ? _buildOverviewTab(isDark, surfaceColor, borderColor, primaryText, secondaryText)
                    : _selectedTab == 1
                        ? _buildTransactionsTab(isDark, surfaceColor, borderColor, primaryText, secondaryText)
                        : _buildPayoutsTab(isDark, surfaceColor, borderColor, primaryText, secondaryText),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  // ── HERO HEADER ─────────────────────────────────────────────────────────────
  Widget _buildHeroHeader(
      bool isDark, Color surfaceColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C1D95),
            Color(0xFF6D28D9),
            Color(0xFF8B5CF6),
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
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -20, left: -40,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16),
                    ),
                  ),
                  const Text(
                    'Earnings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showWithdrawSheet(context, isDark),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.25)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_balance_wallet_rounded,
                              color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text('Withdraw',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Big revenue display
              Text('Total Revenue',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'GHS ${_totalRevenue[_selectedPeriod]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34D399).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up_rounded,
                            color: Color(0xFF34D399), size: 12),
                        const SizedBox(width: 4),
                        Text(_growth[_selectedPeriod]!,
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Text('vs previous ${_periods[_selectedPeriod].toLowerCase()}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PERIOD SELECTOR ──────────────────────────────────────────────────────────
  Widget _buildPeriodSelector(
      bool isDark, Color surfaceColor, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: List.generate(_periods.length, (i) {
            final selected = i == _selectedPeriod;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedPeriod = i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF8B5CF6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    _periods[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : isDark
                              ? Colors.white.withOpacity(0.45)
                              : const Color(0xFF64748B),
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
    );
  }

  // ── BAR CHART ────────────────────────────────────────────────────────────────
  Widget _buildChart(
      bool isDark, Color surfaceColor, Color borderColor) {
    final data = _chartData[_selectedPeriod]!;
    final labels = _chartLabels[_selectedPeriod]!;
    final maxVal = data.reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                Text('Revenue chart',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_periods[_selectedPeriod],
                    style: const TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(data.length, (i) {
                  final heightFraction = data[i] / maxVal;
                  final isHighest = data[i] == maxVal;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: Duration(
                                milliseconds: 400 + (i * 60)),
                            curve: Curves.easeOutCubic,
                            height: 96 * heightFraction,
                            decoration: BoxDecoration(
                              color: isHighest
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFF8B5CF6)
                                      .withOpacity(isDark ? 0.3 : 0.2),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(labels[i],
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withOpacity(0.35)
                                  : const Color(0xFF94A3B8),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── MINI STATS ───────────────────────────────────────────────────────────────
  Widget _buildMiniStats(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    final stats = [
      {
        'label': 'Orders',
        'value': '24',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFF8B5CF6),
        'sub': '+3 today',
      },
      {
        'label': 'Avg. Order',
        'value': 'GHS 52',
        'icon': Icons.receipt_rounded,
        'color': const Color(0xFF06B6D4),
        'sub': '+GHS 4',
      },
      {
        'label': 'Refunds',
        'value': '1',
        'icon': Icons.undo_rounded,
        'color': const Color(0xFFEF4444),
        'sub': 'GHS 50',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: stats.map((s) {
          final color = s['color'] as Color;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: s == stats.last ? 0 : 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(s['icon'] as IconData,
                        color: color, size: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(s['value'] as String,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(s['label'] as String,
                    style: TextStyle(
                        color: secondaryText, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(s['sub'] as String,
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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

  // ── BALANCE CARD ─────────────────────────────────────────────────────────────
  Widget _buildBalanceCard(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF064E3B), Color(0xFF065F46)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('GHS 840.40',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Next payout: Dec 15, 2024',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => _showWithdrawSheet(context, isDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 11),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34D399),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF34D399)
                              .withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Text('Withdraw',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Text('History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  // ── TAB BAR ──────────────────────────────────────────────────────────────────
  Widget _buildTabBar(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText) {
    final tabs = ['Overview', 'Transactions', 'Payouts'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == _selectedTab;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedTab = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF8B5CF6)
                    : surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF8B5CF6)
                      : borderColor,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Text(tabs[i],
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : isDark
                          ? Colors.white.withOpacity(0.45)
                          : const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── OVERVIEW TAB ─────────────────────────────────────────────────────────────
  Widget _buildOverviewTab(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    final topProducts = [
      {'name': 'Electric Kettle', 'sales': 12, 'revenue': 'GHS 2,880', 'color': const Color(0xFF8B5CF6)},
      {'name': 'Laptop Stand', 'sales': 9, 'revenue': 'GHS 1,620', 'color': const Color(0xFF06B6D4)},
      {'name': 'Wireless Mouse', 'sales': 7, 'revenue': 'GHS 665', 'color': const Color(0xFF34D399)},
      {'name': 'USB-C Hub', 'sales': 5, 'revenue': 'GHS 1,600', 'color': const Color(0xFFF59E0B)},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Products
          Text('Top products',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          ...topProducts.map((p) {
            final color = p['color'] as Color;
            final sales = p['sales'] as int;
            final maxSales = 12;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.inventory_2_rounded,
                        color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(p['name'] as String,
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: sales / maxSales,
                            backgroundColor: color
                                .withOpacity(0.1),
                            valueColor:
                                AlwaysStoppedAnimation(color),
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('$sales sales',
                          style: TextStyle(
                              color: secondaryText,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(p['revenue'] as String,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Category breakdown
          Text('By category',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildCategoryRow('Electronics', 0.62,
                    const Color(0xFF8B5CF6), isDark, secondaryText),
                const SizedBox(height: 12),
                _buildCategoryRow('Accessories', 0.24,
                    const Color(0xFF06B6D4), isDark, secondaryText),
                const SizedBox(height: 12),
                _buildCategoryRow('Home', 0.14,
                    const Color(0xFF34D399), isDark, secondaryText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String label, double fraction,
      Color color, bool isDark, Color secondaryText) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : const Color(0xFF374151),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('${(fraction * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── TRANSACTIONS TAB ─────────────────────────────────────────────────────────
  Widget _buildTransactionsTab(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          // Filter row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: isDark
                              ? Colors.white.withOpacity(0.3)
                              : const Color(0xFFADB5C7),
                          size: 18),
                      const SizedBox(width: 8),
                      Text('Search transactions...',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.3)
                              : const Color(0xFFADB5C7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(Icons.tune_rounded,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : const Color(0xFF64748B),
                    size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._transactions.map((t) =>
              _buildTransactionTile(t, isDark, surfaceColor,
                  borderColor, primaryText, secondaryText)),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
      Map<String, dynamic> t,
      bool isDark,
      Color surfaceColor,
      Color borderColor,
      Color primaryText,
      Color secondaryText) {
    final status = t['status'] as String;
    Color statusColor;
    String statusLabel;
    if (status == 'completed') {
      statusColor = const Color(0xFF34D399);
      statusLabel = 'Completed';
    } else if (status == 'pending') {
      statusColor = const Color(0xFFF59E0B);
      statusLabel = 'Pending';
    } else {
      statusColor = const Color(0xFFEF4444);
      statusLabel = 'Refunded';
    }

    final isNegative = (t['amount'] as String).startsWith('-');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: (t['color'] as Color).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(t['avatar'] as String,
                style: TextStyle(
                  color: t['color'] as Color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['name'] as String,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(t['item'] as String,
                  style: TextStyle(
                      color: secondaryText, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(t['amount'] as String,
                style: TextStyle(
                  color: isNegative
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF34D399),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(t['time'] as String,
                style: TextStyle(
                    color: secondaryText, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PAYOUTS TAB ──────────────────────────────────────────────────────────────
  Widget _buildPayoutsTab(bool isDark, Color surfaceColor,
      Color borderColor, Color primaryText, Color secondaryText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payout methods
          Text('Payout methods',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          _buildPayoutMethodCard(
            isDark: isDark,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            primaryText: primaryText,
            secondaryText: secondaryText,
            icon: Icons.phone_android_rounded,
            label: 'MTN Mobile Money',
            detail: '024 **** 5678',
            isDefault: true,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 10),
          _buildPayoutMethodCard(
            isDark: isDark,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            primaryText: primaryText,
            secondaryText: secondaryText,
            icon: Icons.account_balance_rounded,
            label: 'Bank Transfer',
            detail: 'GCB Bank — **** 3412',
            isDefault: false,
            color: const Color(0xFF06B6D4),
          ),
          const SizedBox(height: 10),
          // Add method button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded,
                      color: Color(0xFF8B5CF6), size: 18),
                  SizedBox(width: 8),
                  Text('Add payout method',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Payout history
          Text('Payout history',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          ..._payouts.map((p) => _buildPayoutHistoryTile(
              p, isDark, surfaceColor, borderColor,
              primaryText, secondaryText)),
        ],
      ),
    );
  }

  Widget _buildPayoutMethodCard({
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required IconData icon,
    required String label,
    required String detail,
    required bool isDefault,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDefault
                ? const Color(0xFF8B5CF6).withOpacity(0.4)
                : borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(detail,
                  style: TextStyle(
                      color: secondaryText, fontSize: 11),
                ),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Default',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Icon(Icons.more_vert_rounded,
                color: isDark
                    ? Colors.white.withOpacity(0.35)
                    : const Color(0xFF94A3B8),
                size: 20),
        ],
      ),
    );
  }

  Widget _buildPayoutHistoryTile(
      Map<String, dynamic> p,
      bool isDark,
      Color surfaceColor,
      Color borderColor,
      Color primaryText,
      Color secondaryText) {
    final isPaid = p['status'] == 'paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: isPaid
                  ? const Color(0xFF34D399).withOpacity(0.1)
                  : const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPaid
                  ? Icons.check_circle_rounded
                  : Icons.hourglass_top_rounded,
              color: isPaid
                  ? const Color(0xFF34D399)
                  : const Color(0xFFF59E0B),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['id'] as String,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text('${p['method']} · ${p['date']}',
                  style: TextStyle(
                      color: secondaryText, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(p['amount'] as String,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid
                      ? const Color(0xFF34D399).withOpacity(0.1)
                      : const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? 'Paid' : 'Processing',
                  style: TextStyle(
                    color: isPaid
                        ? const Color(0xFF34D399)
                        : const Color(0xFFF59E0B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── WITHDRAW BOTTOM SHEET ────────────────────────────────────────────────────
  void _showWithdrawSheet(BuildContext context, bool isDark) {
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
            Text('Withdraw funds',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text('Available: GHS 840.40',
              style: TextStyle(
                  color: const Color(0xFF34D399),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
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
                  prefixIcon: Icon(Icons.currency_exchange_rounded,
                      color: const Color(0xFF8B5CF6), size: 20),
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
                  backgroundColor: const Color(0xFF7C3AED),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Confirm withdrawal',
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
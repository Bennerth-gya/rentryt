import 'package:comfi/components/section_container.dart';
import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:comfi/widgets/responsive/responsive_wrapper.dart';
import 'package:flutter/material.dart';

class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> {
  String _selectedFilter = 'All';

  static const List<String> _filters = <String>[
    'All',
    'In transit',
    'Delivered',
    'Negotiated',
  ];

  static const List<_BuyerOrderItem> _orders = <_BuyerOrderItem>[
    _BuyerOrderItem(
      id: 'CF-10482',
      title: 'Nike Air Max 270',
      vendor: 'KofiSneaks',
      status: 'In transit',
      dateLabel: 'Arriving Apr 26',
      amount: 310,
      negotiated: true,
      accent: Color(0xFF8B5CF6),
    ),
    _BuyerOrderItem(
      id: 'CF-10463',
      title: 'Electric Kettle',
      vendor: 'Ama Electronics',
      status: 'Delivered',
      dateLabel: 'Delivered Apr 20',
      amount: 250,
      negotiated: false,
      accent: Color(0xFF0EA5E9),
    ),
    _BuyerOrderItem(
      id: 'CF-10429',
      title: 'Ladies Handbag',
      vendor: 'Abena Boutique',
      status: 'Negotiated',
      dateLabel: 'Awaiting payment',
      amount: 95,
      negotiated: true,
      accent: Color(0xFF10B981),
    ),
    _BuyerOrderItem(
      id: 'CF-10398',
      title: 'Rich Dad Poor Dad',
      vendor: 'BookWorm GH',
      status: 'Delivered',
      dateLabel: 'Delivered Apr 12',
      amount: 60,
      negotiated: false,
      accent: Color(0xFFF59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);
    final filteredOrders = _selectedFilter == 'All'
        ? _orders
        : _orders.where((order) => order.status == _selectedFilter).toList();
    final summaryCards = <_OrderMetric>[
      _OrderMetric(
        label: 'Active orders',
        value: '${_orders.where((order) => order.status == 'In transit').length}',
        accent: const Color(0xFF8B5CF6),
      ),
      _OrderMetric(
        label: 'Delivered',
        value: '${_orders.where((order) => order.status == 'Delivered').length}',
        accent: const Color(0xFF10B981),
      ),
      _OrderMetric(
        label: 'Saved from deals',
        value: 'GHS 125',
        accent: const Color(0xFFF59E0B),
      ),
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveWrapper(
            maxWidth: 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrdersHeader(
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = Responsive.isDesktop(context) ? 3 : 1;
                    final cardWidth = columns == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 32) / columns;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: summaryCards
                          .map(
                            (metric) => SizedBox(
                              width: cardWidth,
                              child: _OrdersMetricCard(metric: metric),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 28),
                SectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recent orders',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${filteredOrders.length} orders',
                              style: const TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _filters
                            .map(
                              (filter) => _OrderFilterChip(
                                label: filter,
                                isSelected: filter == _selectedFilter,
                                onTap: () => setState(() => _selectedFilter = filter),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final gridCount = Responsive.isDesktop(context)
                              ? 2
                              : Responsive.isTablet(context)
                              ? 2
                              : 1;
                          final cardWidth = gridCount == 1
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 16) / gridCount;

                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: filteredOrders
                                .map(
                                  (order) => SizedBox(
                                    width: cardWidth,
                                    child: _BuyerOrderCard(order: order),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
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

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.primaryText,
    required this.secondaryText,
  });

  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orders',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track deliveries, manage negotiated purchases, and keep payment follow-ups in one place.',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrdersMetricCard extends StatelessWidget {
  const _OrdersMetricCard({required this.metric});

  final _OrderMetric metric;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: metric.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.insights_rounded, color: metric.accent),
          ),
          const SizedBox(height: 18),
          Text(
            metric.value,
            style: TextStyle(
              color: primaryText,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderFilterChip extends StatelessWidget {
  const _OrderFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      label: Text(label),
      showCheckmark: false,
      side: BorderSide(
        color: isSelected
            ? const Color(0xFF8B5CF6)
            : const Color(0xFFE2E8F0),
      ),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
      labelStyle: TextStyle(
        color: isSelected
            ? const Color(0xFF8B5CF6)
            : const Color(0xFF64748B),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BuyerOrderCard extends StatelessWidget {
  const _BuyerOrderCard({required this.order});

  final _BuyerOrderItem order;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: order.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: order.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                order.id,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            order.title,
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Seller: ${order.vendor}',
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _OrderInfoTile(
                  label: 'Timeline',
                  value: order.dateLabel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OrderInfoTile(
                  label: 'Amount',
                  value: 'GHS ${order.amount.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
          if (order.negotiated) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.16),
                ),
              ),
              child: const Text(
                'Negotiated price secured. Complete payment or open chat to continue the deal.',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderInfoTile extends StatelessWidget {
  const _OrderInfoTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerOrderItem {
  const _BuyerOrderItem({
    required this.id,
    required this.title,
    required this.vendor,
    required this.status,
    required this.dateLabel,
    required this.amount,
    required this.negotiated,
    required this.accent,
  });

  final String id;
  final String title;
  final String vendor;
  final String status;
  final String dateLabel;
  final double amount;
  final bool negotiated;
  final Color accent;
}

class _OrderMetric {
  const _OrderMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;
}

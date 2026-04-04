
import 'package:comfi/pages/seller_order_details_screen.dart';
import 'package:comfi/pages/sellers_refund_screen.dart';
import 'package:flutter/material.dart';

import '../consts/theme_toggle_button.dart';

class SellerOrdersScreen extends StatefulWidget {
  final int initialTab;
  const SellerOrdersScreen({super.key, this.initialTab = 0});

  @override
  State<SellerOrdersScreen> createState() =>
      _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _dummyOrders = [
    {
      'id': '100140',
      'date': '12 Oct, 2024',
      'amount': '583.00',
      'status': 'Pending',
      'payment': 'Cash on Delivery',
      'customer': 'Kwame Asante',
      'items': 2,
    },
    {
      'id': '100138',
      'date': '11 Oct, 2024',
      'amount': '23,040.00',
      'status': 'Delivered',
      'payment': 'Mobile Money',
      'customer': 'Abena Mensah',
      'items': 5,
    },
    {
      'id': '100137',
      'date': '10 Oct, 2024',
      'amount': '5,400.00',
      'status': 'Delivered',
      'payment': 'Mobile Money',
      'customer': 'Kofi Boateng',
      'items': 3,
    },
    {
      'id': '100135',
      'date': '09 Oct, 2024',
      'amount': '4,808.00',
      'status': 'Pending',
      'payment': 'Cash on Delivery',
      'customer': 'Ama Owusu',
      'items': 1,
    },
    {
      'id': '100134',
      'date': '08 Oct, 2024',
      'amount': '6,490.00',
      'status': 'Packaging',
      'payment': 'Mobile Money',
      'customer': 'Yaw Darko',
      'items': 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Status helpers ──────────────────────────────
  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':   return const Color(0xFFF59E0B);
      case 'Packaging': return const Color(0xFF06B6D4);
      case 'Delivered': return const Color(0xFF34D399);
      default:          return const Color(0xFF8B5CF6);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Pending':   return Icons.hourglass_empty_rounded;
      case 'Packaging': return Icons.inventory_2_rounded;
      case 'Delivered': return Icons.check_circle_rounded;
      default:          return Icons.receipt_long_rounded;
    }
  }

  int _countFor(String? status) {
    if (status == null) return _dummyOrders.length;
    return _dummyOrders
        .where((o) => o['status'] == status)
        .length;
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
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    final tabs = [
      {'label': 'All',       'status': null},
      {'label': 'Pending',   'status': 'Pending'},
      {'label': 'Packaging', 'status': 'Packaging'},
      {'label': 'Delivered', 'status': 'Delivered'},
    ];

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
        title: Text('My Orders',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: surfaceColor,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFF8B5CF6),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: const Color(0xFF8B5CF6),
              unselectedLabelColor: secondaryText,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 8),
              tabs: tabs.map((t) {
                final count =
                    _countFor(t['status']);
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t['label'] as String),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets
                            .symmetric(
                            horizontal: 7,
                            vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6)
                              .withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
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

      body: TabBarView(
        controller: _tabController,
        children: tabs.map((t) {
          final status = t['status'];
          final orders = status == null
              ? _dummyOrders
              : _dummyOrders
                  .where((o) => o['status'] == status)
                  .toList();

          if (orders.isEmpty) {
            return _EmptyOrders(
              status: t['label'] as String,
              isDark: isDark,
              primaryText: primaryText,
              secondaryText: secondaryText,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
                16, 16, 16, 100),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final status = order['status'] as String;
              final color = _statusColor(status);
              final icon  = _statusIcon(status);

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SellerOrderDetailsScreen(
                      order: order,
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius:
                        BorderRadius.circular(20),
                    border: Border.all(
                        color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: color
                            .withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      // ── Top color bar ─────────
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              const BorderRadius.only(
                            topLeft:
                                Radius.circular(20),
                            topRight:
                                Radius.circular(20),
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            // Order ID + date
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: const Color(
                                                0xFF8B5CF6)
                                            .withOpacity(
                                                0.1),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    8),
                                      ),
                                      child: Text(
                                        '#${order['id']}',
                                        style:
                                            const TextStyle(
                                          color: Color(
                                              0xFF8B5CF6),
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 8),
                                    Text(
                                      order['date']
                                          as String,
                                      style: TextStyle(
                                        color:
                                            secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                // Amount
                                Text(
                                  'GHS ${order['amount']}',
                                  style:
                                      const TextStyle(
                                    color: Color(
                                        0xFF8B5CF6),
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Customer + items
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration:
                                      BoxDecoration(
                                    color: const Color(
                                            0xFF8B5CF6)
                                        .withOpacity(
                                            0.1),
                                    shape:
                                        BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons
                                        .person_rounded,
                                    color: Color(
                                        0xFF8B5CF6),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(
                                    width: 8),
                                Expanded(
                                  child: Text(
                                    order['customer']
                                        as String,
                                    style: TextStyle(
                                      color:
                                          primaryText,
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${order['items']} item${(order['items'] as int) > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    color:
                                        secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Status + payment row
                            Row(
                              children: [
                                // Status chip
                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: color
                                        .withOpacity(
                                            0.12),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                    border: Border.all(
                                      color: color
                                          .withOpacity(
                                              0.25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [
                                      Icon(icon,
                                          color:
                                              color,
                                          size: 12),
                                      const SizedBox(
                                          width: 5),
                                      Text(
                                        status,
                                        style:
                                            TextStyle(
                                          color:
                                              color,
                                          fontSize:
                                              11,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                    width: 8),

                                // Payment method
                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: isDark
                                        ? const Color(
                                            0xFF1F2937)
                                        : const Color(
                                            0xFFEEF1FB),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                  ),
                                  child: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [
                                      Icon(
                                        Icons
                                            .payment_rounded,
                                        size: 12,
                                        color:
                                            secondaryText,
                                      ),
                                      const SizedBox(
                                          width: 5),
                                      Text(
                                        order['payment']
                                            as String,
                                        style:
                                            TextStyle(
                                          color:
                                              secondaryText,
                                          fontSize:
                                              11,
                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Refund button
                                if (status ==
                                        'Delivered' ||
                                    status ==
                                        'Pending')
                                  GestureDetector(
                                    onTap: () =>
                                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SellerRefundScreen(
                                          order:
                                              order,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal:
                                            10,
                                        vertical: 5,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: const Color(
                                                0xFF8B5CF6)
                                            .withOpacity(
                                                0.1),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    20),
                                        border:
                                            Border.all(
                                          color: const Color(
                                                  0xFF8B5CF6)
                                              .withOpacity(
                                                  0.2),
                                        ),
                                      ),
                                      child:
                                          const Row(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min,
                                        children: [
                                          Icon(
                                            Icons
                                                .refresh_rounded,
                                            size: 12,
                                            color: Color(
                                                0xFF8B5CF6),
                                          ),
                                          SizedBox(
                                              width:
                                                  4),
                                          Text(
                                            'Refund',
                                            style:
                                                TextStyle(
                                              color: Color(
                                                  0xFF8B5CF6),
                                              fontSize:
                                                  11,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
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
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyOrders extends StatelessWidget {
  final String status;
  final bool isDark;
  final Color primaryText;
  final Color secondaryText;

  const _EmptyOrders({
    required this.status,
    required this.isDark,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6)
                  .withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF8B5CF6)
                    .withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: const Color(0xFF8B5CF6)
                  .withOpacity(0.5),
              size: 36,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No $status orders',
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here\nonce customers place them',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
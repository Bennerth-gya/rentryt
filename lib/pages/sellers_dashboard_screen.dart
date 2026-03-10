import 'package:comfi/consts/colors.dart';
import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  /// -------------------------
  /// ANALYTICS CARD
  /// -------------------------
  static Widget _analyticsCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B4EFF), size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: background,
          elevation: 0,
          title: const Text(
            "Business Analytics",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DropdownButton<String>(
                value: "Overall",
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: cardColor,
                items: ["Overall", "This Month", "This Year"]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
              ),
            ),
          ],

          bottom: const TabBar(
            indicatorColor: Colors.purpleAccent,
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "Sales"),
              Tab(text: "Products"),
            ],
          ),
        ),

        body: TabBarView(
          children: [_buildOverview(), _buildSalesTab(), _buildProductsTab()],
        ),
      ),
    );
  }

  /// -------------------------
  /// OVERVIEW TAB
  /// -------------------------
  static Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ANALYTICS GRID (MERGED CODE)
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _analyticsCard("Total Sales", "GHS 980", Icons.attach_money),
              _analyticsCard("Orders", "24", Icons.shopping_bag),
              _analyticsCard("Customers", "12", Icons.people),
              _analyticsCard("Visits", "180", Icons.show_chart),
            ],
          ),

          const SizedBox(height: 32),

          const Text(
            "Ongoing Orders",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              _OrderStatCard(
                title: "Pending Orders",
                count: "3",
                color: Colors.blue,
              ),
              _OrderStatCard(
                title: "Packaging Orders",
                count: "1",
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              _OrderStatCard(
                title: "Confirmed Orders",
                count: "4",
                color: Colors.green,
              ),
              _OrderStatCard(
                title: "Out For Delivery",
                count: "2",
                color: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// COMPLETED ORDERS
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(
                    icon: Icons.check_circle,
                    label: "Delivered",
                    count: "10",
                    color: Colors.green,
                  ),
                  Divider(color: Colors.white24),
                  _SummaryRow(
                    icon: Icons.cancel,
                    label: "Cancelled",
                    count: "1",
                    color: Colors.red,
                  ),
                  Divider(color: Colors.white24),
                  _SummaryRow(
                    icon: Icons.replay,
                    label: "Return",
                    count: "1",
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          /// EARNINGS
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MiniStat("This Year", "GHS 12,450", Colors.greenAccent),
                  _MiniStat("This Month", "GHS 3,280", Colors.blueAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SALES TAB
  static Widget _buildSalesTab() {
    return const Center(
      child: Text(
        "Sales Analytics Coming Soon",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  /// PRODUCTS TAB
  static Widget _buildProductsTab() {
    return const Center(
      child: Text(
        "Products Overview Coming Soon",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

/// ORDER STAT CARD
class _OrderStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _OrderStatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// SUMMARY ROW
class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        Text(
          count,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// MINI STAT
class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MiniStat(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

import 'package:comfi/consts/colors.dart';
import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background, // your dark background
      appBar: AppBar(
        title: const Text(
          "Business Analytics",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: background,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButton<String>(
              value: "Overall",
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: ["Overall", "This Month", "This Year"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                // TODO: filter data
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ongoing Orders Section
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStatCard(
                  title: "Pending Orders",
                  count: "3",
                  color: Colors.blue,
                ),
                _buildOrderStatCard(
                  title: "Packaging Orders",
                  count: "1",
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStatCard(
                  title: "Confirmed Orders",
                  count: "4",
                  color: Colors.green,
                ),
                _buildOrderStatCard(
                  title: "Out For Delivery",
                  count: "2",
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Completed Orders Summary
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Completed Orders",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow(
                      icon: Icons.check_circle,
                      label: "Delivered",
                      count: "10",
                      color: Colors.green,
                    ),
                    const Divider(color: Colors.white24),
                    _buildSummaryRow(
                      icon: Icons.cancel,
                      label: "Cancelled",
                      count: "1",
                      color: Colors.red,
                    ),
                    const Divider(color: Colors.white24),
                    _buildSummaryRow(
                      icon: Icons.replay,
                      label: "Return",
                      count: "1",
                      color: Colors.orange,
                    ),
                    const Divider(color: Colors.white24),
                    _buildSummaryRow(
                      icon: Icons.warning,
                      label: "Failed to Delivery",
                      count: "2",
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Quick Earnings / Stats (optional extension)
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Earnings Statistics",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniStat(
                          "This Year",
                          "\$12,450",
                          Colors.greenAccent,
                        ),
                        _buildMiniStat(
                          "This Month",
                          "\$3,280",
                          Colors.blueAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80), // space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatCard({
    required String title,
    required String count,
    required Color color,
  }) {
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
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
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

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

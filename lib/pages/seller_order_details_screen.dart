import 'package:comfi/consts/colors.dart';
import 'package:flutter/material.dart';

class SellerOrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const SellerOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          "Order#${order["id"]}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: background,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    (order["status"] == "Pending"
                            ? Colors.orange
                            : order["status"] == "Delivered"
                            ? Colors.green
                            : Colors.blue)
                        .withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    order["icon"] as IconData,
                    color: order["iconColor"] as Color,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Order is ${order["status"]}",
                        style: TextStyle(
                          color: order["iconColor"] as Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "12 Oct, 2022",
                        style: TextStyle(color: textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Verification Code
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Verification Code",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "709795", // dummy
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Address Info
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Address Info",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.map,
                              color: Color(0xFF6B4EFF),
                              size: 20,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Show Map"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    _buildAddressRow(
                      "Shipping",
                      "Fatema",
                      "+233 551 234 567",
                      "Market Street, Tarkwa",
                    ),
                    const Divider(color: Colors.white24),
                    _buildAddressRow(
                      "Billing",
                      "Fatema",
                      "+233 551 234 567",
                      "Market Street, Tarkwa",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Order Summary
            Card(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderItem("Women's Shoes", "GHC 250.00", "Qty: 1"),
                    const Divider(color: Colors.white24),
                    _buildPriceRow("Sub Total", "GHC 5,000.00"),
                    _buildPriceRow(
                      "Tax Total",
                      "+ GHC 250.00",
                      isPositive: true,
                    ),
                    _buildPriceRow("Tax", "+ GHC 250.00", isPositive: true),
                    _buildPriceRow(
                      "Discount",
                      "- GHC 500.00",
                      isPositive: false,
                    ),
                    const Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Grand Total",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "GHC 5,000.00",
                          style: TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: handle order actions (accept, ship, etc.)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EFF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Order Setup",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow(
    String type,
    String name,
    String phone,
    String address,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white)),
          Text(phone, style: const TextStyle(color: Colors.white70)),
          Text(address, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String price, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.white54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white)),
                Text(qty, style: TextStyle(color: textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isPositive = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textSecondary)),
          Text(
            value,
            style: TextStyle(
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}

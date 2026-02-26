import 'package:comfi/consts/colors.dart';
import 'package:comfi/pages/seller_order_details_screen.dart';
import 'package:flutter/material.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: background,
        elevation: 0,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF6B4EFF),
          labelColor: const Color(0xFF6B4EFF),
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Pending"),
            Tab(text: "Packaging"),
            Tab(text: "Delivered"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(statusFilter: null), // All
          _buildOrderList(statusFilter: "Pending"),
          _buildOrderList(statusFilter: "Packaging"),
          _buildOrderList(statusFilter: "Delivered"),
        ],
      ),
    );
  }

  Widget _buildOrderList({String? statusFilter}) {
    // Dummy data – later replace with real orders from provider or API
    final dummyOrders = [
      {
        "id": "100140",
        "date": "12 Oct, 2022",
        "amount": "583.00",
        "status": "Pending",
        "payment": "Cash on Delivery",
        "icon": Icons.hourglass_empty,
        "iconColor": Colors.orange,
      },
      {
        "id": "100138",
        "date": "12 Oct, 2022",
        "amount": "23,040.00",
        "status": "Delivered",
        "payment": "Cash on Delivery",
        "icon": Icons.check_circle,
        "iconColor": Colors.green,
      },
      {
        "id": "100137",
        "date": "12 Oct, 2022",
        "amount": "5,400.00",
        "status": "Delivered",
        "payment": "Stripe",
        "icon": Icons.check_circle,
        "iconColor": Colors.green,
      },
      {
        "id": "100135",
        "date": "12 Oct, 2022",
        "amount": "4,808.00",
        "status": "Pending",
        "payment": "Cash on Delivery",
        "icon": Icons.hourglass_empty,
        "iconColor": Colors.orange,
      },
      {
        "id": "100134",
        "date": "12 Oct, 2022",
        "amount": "6,490.00",
        "status": "Packaging",
        "payment": "Mobile Money",
        "icon": Icons.local_shipping,
        "iconColor": Colors.blue,
      },
    ];

    final filteredOrders = statusFilter == null
        ? dummyOrders
        : dummyOrders.where((o) => o["status"] == statusFilter).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          "No $statusFilter orders yet",
          style: TextStyle(color: textSecondary, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellerOrderDetailsScreen(order: order),
              ),
            );
          },
          child: Card(
            color: cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order#${order["id"]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        order["date"].toString(),
                        style: TextStyle(color: textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        order["icon"] as IconData,
                        color: order["iconColor"] as Color,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order["status"].toString(),
                        style: TextStyle(
                          color: order["iconColor"] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "GHC ${order["amount"]}",
                        style: const TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Payment: ${order["payment"]}",
                    style: TextStyle(color: textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

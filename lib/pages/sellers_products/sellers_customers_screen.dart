import 'package:comfi/consts/colors.dart'; // Assuming you have this
import 'package:flutter/material.dart';

class SellersCustomersScreen extends StatefulWidget {
  const SellersCustomersScreen({super.key});

  @override
  State<SellersCustomersScreen> createState() => _SellersCustomersScreenState();
}

class _SellersCustomersScreenState extends State<SellersCustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy data — replace with your API / Firestore fetch
  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Ama Mensah',
      'email': 'ama.mensah@gmail.com',
      'phone': '+233 24 123 4567',
      'orders': 12,
      'joined': 'Jan 2025',
    },
    {
      'name': 'Kwame Boateng',
      'email': 'kwameb@outlook.com',
      'phone': '+233 54 987 6543',
      'orders': 8,
      'joined': 'Mar 2025',
    },
    {
      'name': 'Efua Osei',
      'email': 'efua.osei@yahoo.com',
      'phone': '+233 27 555 8888',
      'orders': 25,
      'joined': 'Feb 2025',
    },
    {
      'name': 'Yaw Asante',
      'email': 'yaw.asante@icloud.com',
      'phone': '+233 20 111 2222',
      'orders': 3,
      'joined': 'Apr 2025',
    },
    // Add more...
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    return _customers.where((customer) {
      final name = customer['name'].toLowerCase();
      final email = customer['email'].toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background, // your const
      appBar: AppBar(
        title: Center(child: const Text("My Customers")),
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search customers...",

                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: cardColor.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          // List
          Expanded(
            child: _filteredCustomers.isEmpty
                ? const Center(
                    child: Text(
                      "No customers found",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return Card(
                        color: cardColor,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(
                              0xFF6B4EFF,
                            ).withOpacity(0.3),
                            child: Text(
                              customer['name'][0].toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF6B4EFF),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            customer['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer['email'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${customer['orders']} orders • Joined ${customer['joined']}",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF6B4EFF),
                            size: 20,
                          ),
                          onTap: () {
                            // TODO: Navigate to Customer Detail Screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tapped ${customer['name']}"),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6B4EFF),
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () {
          // TODO: Add new customer logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add new customer feature coming soon"),
            ),
          );
        },
      ),
    );
  }
}

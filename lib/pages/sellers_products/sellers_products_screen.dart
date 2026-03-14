// sellers_products/sellers_products_screen.dart
import 'package:comfi/consts/colors.dart';
import 'package:flutter/material.dart';

class SellersProductsScreen extends StatelessWidget {
  SellersProductsScreen({super.key});

  // Dummy data — replace with real fetch
  final List<Map<String, dynamic>> products = [
    {
      'name': "Hot Plate",
      'price': 'GHS 680',
      'rating': 4.4,
      'image': 'assets/images/hotplate.jpg',
    },
    {
      'name': "Men's Shirt",
      'price': 'GHS 100',
      'rating': 4.0,
      'image': 'assets/images/men_shirt1.jpg',
    },
    {
      'name': 'Study lamp',
      'price': 'GHS 690',
      'rating': 4.4,
      'image': 'assets/images/study_lamp.jpg',
    },
    {
      'name': "Men's Slippers",
      'price': 'GHS 399',
      'rating': 3.6,
      'image': 'assets/images/slipper2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Center(
          child: const Text(
            "My Productss",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF6B4EFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              /* Add product */
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overview for your 24 products",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.49,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return GestureDetector(
                    onTap: () {
                      /* Go to edit product */
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              p['image'], // use network images later
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p['price'],
                                  style: const TextStyle(
                                    color: Color(0xFF6B4EFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      " ${p['rating']}",
                                      style: const TextStyle(
                                        color: Colors.white70,
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6B4EFF),
        child: const Icon(Icons.add),
        onPressed: () {
          /* Add new product */
        },
      ),
    );
  }
}

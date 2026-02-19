import 'package:comfi/pages/shop_page.dart';
import 'package:comfi/payment/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:comfi/components/cart_item.dart';
import 'package:comfi/models/cart.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
        children: [
          // Heading
          const Text(
            'My Cart',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),

          const SizedBox(height: 20),

          if (value.userCart.isEmpty) ...[
            const SizedBox(height: 200),
            const Center(
              child: Text("Your Cart is Empty", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => ShopPage()),
            //       );
            //     },
            //     child: const Text("Shop Now"),
            //   ),
            // ),
          ] else ...[
            // Cart Items
            ...value.userCart.entries.map((entry) {
              return CartItem(product: entry.key, quantity: entry.value);
            }).toList(),

            const SizedBox(height: 40),

            // TOTAL + CHECKOUT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${value.getTotalPrice().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // ← Add this anonymous function
                        Navigator.push(
                          context, // ← you need context here
                          MaterialPageRoute(
                            builder: (context) =>
                                const PaymentMethod(), // ← your target screen
                          ),
                        );
                      },
                      child: const Text("Checkout"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

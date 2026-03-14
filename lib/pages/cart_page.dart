import 'package:comfi/pages/shop_page.dart';
import 'package:comfi/payment/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:comfi/components/cart_item.dart';
import 'package:comfi/models/cart.dart';
import 'package:provider/provider.dart';
import 'package:comfi/consts/colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: const Text("My Cart", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: background,
      ),
      body: Consumer<Cart>(
        builder: (context, value, child) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
          children: [
            /// HEADING
            const Text(
              'My Cart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 20),

            /// EMPTY CART
            if (value.userCart.isEmpty) ...[
              const SizedBox(height: 200),

              const Center(
                child: Text(
                  "Your Cart is Empty",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              /// SHOP NOW BUTTON
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopPage()),
                    );
                  },
                  child: const Text("Shop Now"),
                ),
              ),
            ]
            /// CART HAS ITEMS
            else ...[
              /// CART ITEMS
              ...value.userCart.entries.map((entry) {
                return CartItem(product: entry.key, quantity: entry.value);
              }).toList(),

              const SizedBox(height: 40),

              /// TOTAL + CHECKOUT
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    /// TOTAL PRICE
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

                    /// CHECKOUT BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentMethod(),
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
      ),
    );
  }
}

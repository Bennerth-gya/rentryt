import 'package:comfi/models/products.dart';
import 'package:comfi/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Products product;

  final int quantity;

  const CartItem({super.key, required this.product, required this.quantity});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void removeItemFromCart() {
    Provider.of<Cart>(
      context,
      listen: false,
    ).removeItemFromCart(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(widget.product.imagePath, width: 60),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("\$${widget.product.price}"),
              ],
            ),
          ),

          // 🔥 Quantity Controls
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<Cart>(
                    context,
                    listen: false,
                  ).decreaseQuantity(widget.product);
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),

              Text(widget.quantity.toString()),

              IconButton(
                onPressed: () {
                  Provider.of<Cart>(
                    context,
                    listen: false,
                  ).increaseQuantity(widget.product);
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),

          IconButton(
            onPressed: removeItemFromCart,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

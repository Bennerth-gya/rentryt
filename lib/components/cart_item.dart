import 'package:comfi/models/products.dart';
import 'package:comfi/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Products product;

  const CartItem({super.key, required this.product});

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
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.asset(
          widget.product.imagePath,
          width: 50,
          fit: BoxFit.cover,
        ),
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price}'),
        trailing: IconButton(
          onPressed: removeItemFromCart,
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}

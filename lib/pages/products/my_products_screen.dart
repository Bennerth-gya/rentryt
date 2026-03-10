import 'package:comfi/components/products_tile.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
// import 'package:comfi/pages/seller/seller_post_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/colors.dart';
import '../seller_post_product_screen.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, _) {
        final myProducts = cart.sellerProducts;

        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: const Text(
                "My Products",
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: cardColor,
          ),
          body: myProducts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "You haven't posted any products yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.48,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: myProducts.length,
                  itemBuilder: (context, index) {
                    final product = myProducts[index];
                    return Stack(
                      children: [
                        ProductsTile(
                          product: product,
                          onAddToCart: () {},
                          isInGrid: true,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              // EDIT
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 22,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SellerPostProductScreen(
                                        productToEdit: product,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // DELETE
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Delete ${product.name}?"),
                                      content: const Text(
                                        "This cannot be undone.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            cart.deleteProduct(product);
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}

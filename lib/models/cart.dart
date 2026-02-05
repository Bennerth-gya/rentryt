import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  // Featured / Popular products (shown in the horizontal scroll or tablet grid above)
  List<Products> featuredProducts = [
    Products(
      name: 'Jersey',
      description: 'Get your favorite jersey',
      price: 80,
      imagePath: 'lib/images/Barcelona-Away-Kit.jpg',
    ),
    Products(
      name: 'HP Laptop',
      description: 'Nice and sleek laptop',
      price: 5000,
      imagePath: 'lib/images/laptop.jpeg',
    ),
    Products(
      name: 'Study lamp',
      description: 'Study throught the night',
      price: 150,
      imagePath: 'lib/images/study_lamp.jpg',
    ),
    // Add 3–6 more featured items with different images
    Products(
      name: 'smart watch',
      description: 'Smart watch',
      price: 45,
      imagePath: 'lib/images/smart_watchj.jpg', // ← new/different image
    ),
    Products(
      name: 'Men\'s shirt',
      description: 'Nice men shirt',
      price: 90,
      imagePath: 'lib/images/men_shirt1.jpg',
    ),
  ];

  // Recommended products (different selection, different images)
  List<Products> recommendedProducts = [
    Products(
      name: "Fada's services",
      description: 'Get all your PPEs here',
      price: 290,
      imagePath: 'lib/images/fada.jpeg',
    ),
    Products(
      name: 'Men shirt',
      description: 'Nice men shirt',
      price: 100,
      imagePath: 'lib/images/men_shirt.jpg',
    ),
    Products(
      name: 'Men\'s african slippers',
      description: 'Nice men slippers',
      price: 80,
      imagePath: 'lib/images/slipper2.jpg', // ← different image
    ),
    Products(
      name: 'Men Shoe',
      description: 'Nice shoe',
      price: 230,
      imagePath: 'lib/images/men_shoe.jpg',
    ),
    Products(
      name: 'Ladies African dress',
      description: 'New style',
      price: 200,
      imagePath: 'lib/images/ladies_african_dress.jpg',
    ),
    Products(
      name: 'Ladies Heels',
      description: 'Classic ladies heels',
      price: 220,
      imagePath: 'lib/images/heels2.jpg',
    ),
    // Add more as needed — ideally 6–12 items
  ];

  // All products (if you want a "View All" or search to show everything)
  List<Products> get allProducts => [
    ...featuredProducts,
    ...recommendedProducts,
  ];

  // ────────────────────────────────────────────────
  // Getter for featured (used in the upper section)
  List<Products> getFeaturedList() {
    return featuredProducts;
  }

  // Getter for recommended (used in the lower section)
  List<Products> getRecommendedList() {
    return recommendedProducts;
  }

  // Your existing cart methods remain the same
  List<Products> userCart = [];

  List<Products> getUserCart() => userCart;

  void addItemToCart(Products product) {
    userCart.add(product);
    notifyListeners();
  }

  void removeItemFromCart(Products product) {
    userCart.remove(product);
    notifyListeners();
  }
}

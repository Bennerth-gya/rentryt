import 'package:flutter/material.dart';
import 'products.dart';

class Cart extends ChangeNotifier {
  // ================================
  // SINGLE SOURCE OF TRUTH — ALL PRODUCTS
  // ================================
  final List<Products> _allProducts = [
    // Electronics
    Products(
      name: "Electric Kettle",
      price: 250.0,
      imagePath: "assets/images/kettle.jpg",
      description: "Fast boiling cordless electric kettle",
      category: "Electronics",
      colors: [],
      sizes: [],
    ),
    Products(
      name: "Laptop",
      price: 1800.0, // ← realistic price (was probably typo)
      imagePath: "assets/images/laptops.jpg",
      description: "Powerful 16GB RAM laptop",
      category: "Electronics",
      colors: [],
      sizes: [],
    ),

    // Men
    Products(
      name: "Men's Shoe",
      price: 180.0,
      imagePath: "assets/images/men_shoe.jpg",
      description: "Comfortable casual men's sneakers",
      category: "Men",
      colors: ["Black", "White", "Grey"],
      sizes: ["40", "41", "42", "43", "44"],
    ),
    Products(
      name: "Men's Slippers",
      price: 120.0,
      imagePath: "assets/images/men_slippers1.jpg",
      description: "Soft indoor men's slippers",
      category: "Men",
      colors: [],
      sizes: [],
    ),
    Products(
      name: "Men's T-Shirt",
      price: 45.0,
      imagePath: "assets/images/men_shirt1.jpg",
      description: "Premium cotton crew-neck T-shirt",
      category: "Men",
      colors: ["Black", "Navy", "White"],
      sizes: ["S", "M", "L", "XL"],
    ),

    // Ladies
    Products(
      name: "Ladies Handbag",
      price: 95.0,
      imagePath: "assets/images/ladies_purse.jpg",
      description: "Stylish genuine leather handbag",
      category: "Ladies",
      colors: ["Tan", "Black", "Red"],
      sizes: [],
    ),
    Products(
      name: "Ladies Dress",
      price: 150.0,
      imagePath: "assets/images/ladies_african_dress.jpg",
      description: "Elegant evening maxi dress",
      category: "Ladies",
      colors: ["Burgundy", "Navy", "Emerald"],
      sizes: ["S", "M", "L"],
    ),

    // Education / Books
    Products(
      name: "Rich Dad Poor Dad",
      price: 60.0,
      imagePath: "assets/images/richdadpoordad.png",
      description: "Rich Dad Poor Dad by Robert Kiyosaki",
      category: "Education",
      colors: [],
      sizes: [],
    ),
  ];

  // ================================
  // DERIVED LISTS (computed when needed)
  // ================================
  List<Products> getFeaturedList() {
    // You can choose any logic — here: first 3 or most expensive, etc.
    return _allProducts.take(3).toList();
  }

  List<Products> getRecommendedList() {
    // Example: random or last added or highest rated, etc.
    return _allProducts.skip(3).take(4).toList();
  }

  // ================================
  // CATEGORY FILTER
  // ================================
  List<Products> getProductsForCategory(String category) {
    if (category == "All") {
      return List.unmodifiable(_allProducts);
    }
    return _allProducts.where((p) => p.category == category).toList();
  }

  // ================================
  // SEARCH (this is what you need for the search bar)
  // ================================
  List<Products> searchProducts(String query) {
    if (query.trim().isEmpty) {
      return List.unmodifiable(_allProducts);
    }

    final lowerQuery = query.toLowerCase().trim();

    return _allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ================================
  // USER CART
  // ================================
  final Map<Products, int> _userCart = {};

  Map<Products, int> get userCart => Map.unmodifiable(_userCart);

  void addItemToCart(Products product) {
    _userCart.update(product, (quantity) => quantity + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeItemFromCart(Products product) {
    _userCart.remove(product);
    notifyListeners();
  }

  void increaseQuantity(Products product) {
    addItemToCart(product); // reuse logic
  }

  void decreaseQuantity(Products product) {
    if (_userCart.containsKey(product)) {
      if (_userCart[product]! > 1) {
        _userCart[product] = _userCart[product]! - 1;
      } else {
        _userCart.remove(product);
      }
      notifyListeners();
    }
  }

  double getTotalPrice() {
    double total = 0;
    _userCart.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }
}

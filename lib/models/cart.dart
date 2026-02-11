import 'package:flutter/foundation.dart';
import 'package:comfi/models/products.dart';

class Cart extends ChangeNotifier {
  final List<Products> _userCart = [];

  // Sample featured products (you can replace with actual data source)
  final List<Products> _featuredList = [
    Products(
      name: "Premium Desk",
      imagePath: "lib/images/laptops.jpg",
      description: "High quality wooden desk",
      price: 299.99,
      colors: ["#8B4513", "#2F4F4F"],
      sizes: ["S", "M", "L"],
      averageRating: 4.5,
      reviewCount: 58,
    ),
    Products(
      name: "Comfort Chair",
      imagePath: "lib/images/smart_watchj.jpg",
      description: "Ergonomic office chair",
      price: 199.99,
      colors: ["#000000", "#FFFFFF"],
      sizes: ["One Size"],
      averageRating: 4.8,
      reviewCount: 256,
    ),
    Products(
      name: "Wall Shelf",
      imagePath: "lib/images/slipper2.jpg",
      description: "Modern floating shelf",
      price: 79.99,
      colors: ["#FFD700", "#C0C0C0"],
      sizes: ["Small", "Large"],
      averageRating: 4.2,
      reviewCount: 64,
    ),
  ];

  // Sample recommended products
  final List<Products> _recommendedList = [
    Products(
      name: "Study Table",
      imagePath: "lib/images/laptops.jpg",
      description: "Perfect for students",
      price: 149.99,
      colors: ["#8B4513"],
      sizes: ["Standard"],
      averageRating: 4.3,
      reviewCount: 92,
    ),
    Products(
      name: "Bedside Lamp",
      imagePath: "lib/images/ladies_african_dress1.jpg",
      description: "Adjustable reading lamp",
      price: 49.99,
      colors: ["#000000", "#FFFFFF"],
      sizes: ["One Size"],
      averageRating: 4.6,
      reviewCount: 178,
    ),
    Products(
      name: "Bookshelf",
      imagePath: "lib/images/study_lamp.jpg",
      description: "5-tier wooden bookshelf",
      price: 249.99,
      colors: ["#8B4513", "#DAA520"],
      sizes: ["M", "L"],
      averageRating: 4.4,
      reviewCount: 134,
    ),
    Products(
      name: "Office Cabinet",
      imagePath: "lib/images/purse.jpg",
      description: "Storage with locking doors",
      price: 399.99,
      colors: ["#2F4F4F"],
      sizes: ["Large"],
      averageRating: 4.7,
      reviewCount: 89,
    ),
  ];

  final Map<String, List<Products>> _categorizedProducts = {
    'All': [],
    'Electronics': [
      Products(
        name: "Desk Lamp",
        imagePath: "lib/images/iron.jpg",
        description: "LED desk lamp",
        price: 59.99,
        colors: ["#FFD700"],
        sizes: ["One Size"],
      ),
      Products(
        name: "Hotplate",
        imagePath: "lib/images/hotplate.jpg",
        description: "4-port USB hub",
        price: 29.99,
        colors: ["#000000"],
        sizes: ["One Size"],
      ),
    ],
    'Education': [
      Products(
        name: "Notebook Pack",
        imagePath: "lib/images/notes.jpg",
        description: "100-page notebooks",
        price: 19.99,
        colors: ["#0000FF", "#FF0000"],
        sizes: ["Standard"],
      ),
      Products(
        name: "Study table",
        imagePath: "lib/images/study_table1.jpg",
        description: "12-piece premium pen set",
        price: 24.99,
        colors: ["#000000"],
        sizes: ["One Size"],
      ),
    ],
    'Men': [
      Products(
        name: "Men slippers",
        imagePath: "lib/images/men_slippers1.jpg",
        description: "Ergonomic office chair",
        price: 199.99,
        colors: ["#000000"],
        sizes: ["One Size"],
      ),
      Products(
        name: "Shoe",
        imagePath: "lib/images/men_shoe.jpg",
        description: "Professional work desk",
        price: 349.99,
        colors: ["#8B4513"],
        sizes: ["Large"],
      ),
    ],
    'Ladies': [
      Products(
        name: "Purse",
        imagePath: "lib/images/ladies_purse.jpg",
        description: "LED vanity mirror",
        price: 89.99,
        colors: ["#FFD700"],
        sizes: ["Standard"],
      ),
      Products(
        name: "Heels",
        imagePath: "lib/images/heels1.jpg",
        description: "Decorative storage",
        price: 129.99,
        colors: ["#DAA520"],
        sizes: ["Medium"],
      ),
    ],
  };

  Cart() {
    // Initialize "All" category with all products
    _categorizedProducts['All'] = [
      ..._featuredList,
      ..._recommendedList,
      ...(_categorizedProducts['Electronics'] ?? []),
      ...(_categorizedProducts['Education'] ?? []),
      ...(_categorizedProducts['Men'] ?? []),
      ...(_categorizedProducts['Ladies'] ?? []),
    ];
  }

  // Get user's cart items
  List<Products> getUserCart() {
    return _userCart;
  }

  // Add item to cart
  void addItemToCart(Products product) {
    _userCart.add(product);
    notifyListeners();
  }

  // Remove item from cart
  void removeItemFromCart(Products product) {
    _userCart.remove(product);
    notifyListeners();
  }

  // Get featured products list
  List<Products> getFeaturedList() {
    return _featuredList;
  }

  // Get recommended products list
  List<Products> getRecommendedList() {
    return _recommendedList;
  }

  // Get products for a specific category
  List<Products> getProductsForCategory(String category) {
    return _categorizedProducts[category] ?? [];
  }
}

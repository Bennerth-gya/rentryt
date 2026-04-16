import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/models/user_model.dart';

abstract final class InMemorySeedData {
  static const String activeSellerId = 'seller_demo_1';

  static List<ProductModel> buildProducts() {
    return <ProductModel>[
      ProductModel(
        id: 'prod-electric-kettle',
        name: 'Electric Kettle',
        price: 250.0,
        imagePath: 'assets/images/kettle.jpg',
        description: 'Fast boiling cordless electric kettle',
        category: 'Electronics',
        colors: const [],
        sizes: const [],
        sellerId: 'seller_ama_electronics',
        sellerName: 'Ama Electronics',
        sellerPhone: '+233 24 000 1111',
        sellerLocation: 'Accra, Ghana',
        inventoryCount: 18,
        salesCount: 124,
      ),
      ProductModel(
        id: 'prod-laptop',
        name: 'Laptop',
        price: 4800.0,
        imagePath: 'assets/images/laptops.jpg',
        description: 'Powerful 16GB RAM laptop',
        category: 'Electronics',
        colors: const [],
        sizes: const [],
        sellerId: 'seller_techhub_gh',
        sellerName: 'TechHub GH',
        sellerPhone: '+233 20 555 2222',
        sellerLocation: 'Kumasi, Ghana',
        inventoryCount: 6,
        salesCount: 42,
      ),
      ProductModel(
        id: 'prod-mens-shoe',
        name: 'Men\'s Shoe',
        price: 180.0,
        imagePath: 'assets/images/men_shoe.jpg',
        description: 'Comfortable casual men\'s sneakers',
        category: 'Men',
        colors: const ['Black', 'White', 'Grey'],
        sizes: const ['40', '41', '42', '43', '44'],
        sellerId: 'seller_kwame_styles',
        sellerName: 'Kwame Styles',
        sellerPhone: '+233 55 123 4567',
        sellerLocation: 'Takoradi, Ghana',
        inventoryCount: 12,
        salesCount: 61,
      ),
      ProductModel(
        id: 'prod-mens-slippers',
        name: 'Men\'s Slippers',
        price: 120.0,
        imagePath: 'assets/images/men_slippers1.jpg',
        description: 'Soft indoor men\'s slippers',
        category: 'Men',
        colors: const [],
        sizes: const [],
        sellerId: 'seller_kwame_styles',
        sellerName: 'Kwame Styles',
        sellerPhone: '+233 55 123 4567',
        sellerLocation: 'Takoradi, Ghana',
        inventoryCount: 7,
        salesCount: 89,
      ),
      ProductModel(
        id: 'prod-mens-tshirt',
        name: 'Men\'s T-Shirt',
        price: 45.0,
        imagePath: 'assets/images/men_shirt1.jpg',
        description: 'Premium cotton crew-neck T-shirt',
        category: 'Men',
        colors: const ['Black', 'Navy', 'White'],
        sizes: const ['S', 'M', 'L', 'XL'],
        sellerId: 'seller_kofi_fashion',
        sellerName: 'Kofi Fashion',
        sellerPhone: '+233 27 888 9999',
        sellerLocation: 'Accra, Ghana',
        inventoryCount: 42,
        salesCount: 101,
      ),
      ProductModel(
        id: 'prod-ladies-handbag',
        name: 'Ladies Handbag',
        price: 95.0,
        imagePath: 'assets/images/ladies_purse.jpg',
        description: 'Stylish genuine leather handbag',
        category: 'Ladies',
        colors: const ['Tan', 'Black', 'Red'],
        sizes: const [],
        sellerId: 'seller_abena_boutique',
        sellerName: 'Abena\'s Boutique',
        sellerPhone: '+233 50 777 3344',
        sellerLocation: 'Accra, Ghana',
        inventoryCount: 14,
        salesCount: 76,
      ),
      ProductModel(
        id: 'prod-ladies-dress',
        name: 'Ladies Dress',
        price: 150.0,
        imagePath: 'assets/images/ladies_african_dress.jpg',
        description: 'Elegant evening maxi dress',
        category: 'Ladies',
        colors: const ['Burgundy', 'Navy', 'Emerald'],
        sizes: const ['S', 'M', 'L'],
        sellerId: 'seller_abena_boutique',
        sellerName: 'Abena\'s Boutique',
        sellerPhone: '+233 50 777 3344',
        sellerLocation: 'Accra, Ghana',
        inventoryCount: 9,
        salesCount: 58,
      ),
      ProductModel(
        id: 'prod-rich-dad-poor-dad',
        name: 'Rich Dad Poor Dad',
        price: 60.0,
        imagePath: 'assets/images/richdadpoordad.png',
        description: 'Rich Dad Poor Dad by Robert Kiyosaki',
        category: 'Education',
        colors: const [],
        sizes: const [],
        sellerId: 'seller_bookworm_gh',
        sellerName: 'BookWorm GH',
        sellerPhone: '+233 24 321 6543',
        sellerLocation: 'Kumasi, Ghana',
        inventoryCount: 27,
        salesCount: 134,
      ),
    ];
  }

  static List<OrderModel> buildSellerOrders() {
    return const <OrderModel>[
      OrderModel(
        id: '100140',
        dateLabel: '12 Oct, 2024',
        amount: 583.00,
        status: 'Pending',
        paymentMethod: 'Cash on Delivery',
        customerName: 'Kwame Asante',
        itemCount: 2,
      ),
      OrderModel(
        id: '100138',
        dateLabel: '11 Oct, 2024',
        amount: 23040.00,
        status: 'Delivered',
        paymentMethod: 'Mobile Money',
        customerName: 'Abena Mensah',
        itemCount: 5,
      ),
      OrderModel(
        id: '100137',
        dateLabel: '10 Oct, 2024',
        amount: 5400.00,
        status: 'Delivered',
        paymentMethod: 'Mobile Money',
        customerName: 'Kofi Boateng',
        itemCount: 3,
      ),
      OrderModel(
        id: '100135',
        dateLabel: '09 Oct, 2024',
        amount: 4808.00,
        status: 'Pending',
        paymentMethod: 'Cash on Delivery',
        customerName: 'Ama Owusu',
        itemCount: 1,
      ),
      OrderModel(
        id: '100134',
        dateLabel: '08 Oct, 2024',
        amount: 6490.00,
        status: 'Packaging',
        paymentMethod: 'Mobile Money',
        customerName: 'Yaw Darko',
        itemCount: 4,
      ),
    ];
  }

  static UserModel demoBuyer() {
    return UserModel(
      id: 'user_demo_buyer',
      name: 'Systrom',
      email: 'gbennerth@gmail.com',
      role: UserRole.buyer,
      phoneNumber: '+233 20 000 0000',
    );
  }

  static UserModel demoSeller() {
    return UserModel(
      id: activeSellerId,
      name: 'Kessie',
      email: 'seller@comfi.app',
      role: UserRole.seller,
      phoneNumber: '+233 24 111 2222',
    );
  }

  static UserModel sellerForProduct(ProductModel product) {
    final sellerName = (product.sellerName?.trim().isNotEmpty ?? false)
        ? product.sellerName!.trim()
        : 'Comfi Seller';
    final sellerId = (product.sellerId?.trim().isNotEmpty ?? false)
        ? product.sellerId!.trim()
        : activeSellerId;
    final normalizedEmail = sellerName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '.')
        .replaceAll(RegExp(r'\.+'), '.')
        .replaceAll(RegExp(r'^\.|\.$'), '');

    return UserModel(
      id: sellerId,
      name: sellerName,
      email:
          '${normalizedEmail.isEmpty ? 'seller' : normalizedEmail}@comfi.app',
      role: UserRole.seller,
      phoneNumber: product.sellerPhone ?? demoSeller().phoneNumber,
    );
  }
}

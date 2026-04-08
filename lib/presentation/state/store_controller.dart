import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/repositories/cart_repository.dart';
import 'package:comfi/data/repositories/order_repository.dart';
import 'package:comfi/data/repositories/product_repository.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';
import 'package:flutter/foundation.dart';

class StoreController extends ChangeNotifier {
  StoreController({
    required ProductRepository productRepository,
    required CartRepository cartRepository,
    OrderRepository? orderRepository,
  })  : _productRepository = productRepository,
        _cartRepository = cartRepository,
        _orderRepository = orderRepository {
    bootstrap();
  }

  final ProductRepository _productRepository;
  final CartRepository _cartRepository;
  final OrderRepository? _orderRepository;

  List<ProductModel> _products = <ProductModel>[];
  List<OrderModel> _sellerOrders = <OrderModel>[];
  Map<String, int> _cartQuantities = <String, int>{};

  bool _isBootstrapping = false;
  String? _errorMessage;

  bool get isBootstrapping => _isBootstrapping;
  String? get errorMessage => _errorMessage;

  List<ProductModel> get allProducts => List<ProductModel>.unmodifiable(_products);

  List<OrderModel> get sellerOrders => List<OrderModel>.unmodifiable(_sellerOrders);

  List<ProductModel> get sellerProducts {
    return List<ProductModel>.unmodifiable(
      _products.where((product) => product.sellerId == InMemorySeedData.activeSellerId),
    );
  }

  Map<ProductModel, int> get userCart {
    final productById = <String, ProductModel>{
      for (final product in _products) product.id: product,
    };

    return Map<ProductModel, int>.unmodifiable({
      for (final entry in _cartQuantities.entries)
        if (productById.containsKey(entry.key)) productById[entry.key]!: entry.value,
    });
  }

  Future<void> bootstrap() async {
    _isBootstrapping = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getProducts();
      _cartQuantities = await _cartRepository.getCartQuantities();
      _sellerOrders = _orderRepository == null
          ? <OrderModel>[]
          : await _orderRepository!.getSellerOrders();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isBootstrapping = false;
      notifyListeners();
    }
  }

  List<ProductModel> getFeaturedList() => _products.take(3).toList();

  List<ProductModel> getRecommendedList() => _products.skip(3).take(4).toList();

  List<ProductModel> getProductsForCategory(String category) {
    if (category == 'All') {
      return List<ProductModel>.unmodifiable(_products);
    }

    return _products.where((product) => product.category == category).toList();
  }

  List<ProductModel> searchProducts(String query) {
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isEmpty) {
      return List<ProductModel>.unmodifiable(_products);
    }

    return _products.where((product) {
      return product.name.toLowerCase().contains(trimmedQuery) ||
          product.description.toLowerCase().contains(trimmedQuery) ||
          product.category.toLowerCase().contains(trimmedQuery) ||
          (product.sellerName?.toLowerCase().contains(trimmedQuery) ?? false);
    }).toList();
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } on StateError {
      return null;
    }
  }

  Future<void> addItemToCart(ProductModel product) async {
    await _cartRepository.addToCart(productId: product.id);
    _cartQuantities = await _cartRepository.getCartQuantities();
    notifyListeners();
  }

  Future<void> removeItemFromCart(ProductModel product) async {
    await _cartRepository.removeFromCart(productId: product.id);
    _cartQuantities = await _cartRepository.getCartQuantities();
    notifyListeners();
  }

  Future<void> increaseQuantity(ProductModel product) => addItemToCart(product);

  Future<void> decreaseQuantity(ProductModel product) async {
    await _cartRepository.decreaseQuantity(productId: product.id);
    _cartQuantities = await _cartRepository.getCartQuantities();
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0;
    final productsById = <String, ProductModel>{
      for (final product in _products) product.id: product,
    };

    for (final entry in _cartQuantities.entries) {
      final product = productsById[entry.key];
      if (product == null) {
        continue;
      }
      total += product.price * entry.value;
    }

    return total;
  }

  Future<void> addNewProduct(ProductModel product) async {
    final preparedProduct = product.copyWith(
      sellerId: product.sellerId ?? InMemorySeedData.activeSellerId,
      status: product.status,
    );
    await _productRepository.addProduct(preparedProduct);
    _products = await _productRepository.getProducts();
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel oldProduct, ProductModel newProduct) async {
    final updatedProduct = newProduct.copyWith(
      id: oldProduct.id,
      sellerId: oldProduct.sellerId ?? newProduct.sellerId ?? InMemorySeedData.activeSellerId,
    );
    await _productRepository.updateProduct(updatedProduct);
    _products = await _productRepository.getProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(ProductModel product) async {
    await _productRepository.deleteProduct(product.id);
    await _cartRepository.clearProduct(product.id);
    _products = await _productRepository.getProducts();
    _cartQuantities = await _cartRepository.getCartQuantities();
    notifyListeners();
  }
}

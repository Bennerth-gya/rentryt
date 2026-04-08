import 'package:comfi/data/services/cart_service.dart';

class CartRepository {
  CartRepository(this._service);

  final CartService _service;

  Future<Map<String, int>> getCartQuantities() => _service.getCartQuantities();

  Future<void> addToCart({required String productId}) =>
      _service.addToCart(productId: productId);

  Future<void> removeFromCart({required String productId}) =>
      _service.removeFromCart(productId: productId);

  Future<void> decreaseQuantity({required String productId}) =>
      _service.decreaseQuantity(productId: productId);

  Future<void> clearProduct(String productId) => _service.clearProduct(productId);
}

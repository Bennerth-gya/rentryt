abstract class CartService {
  Future<Map<String, int>> getCartQuantities();
  Future<void> addToCart({required String productId});
  Future<void> removeFromCart({required String productId});
  Future<void> decreaseQuantity({required String productId});
  Future<void> clearProduct(String productId);
}

class InMemoryCartService implements CartService {
  final Map<String, int> _quantities = <String, int>{};

  @override
  Future<Map<String, int>> getCartQuantities() async {
    return Map<String, int>.from(_quantities);
  }

  @override
  Future<void> addToCart({required String productId}) async {
    _quantities.update(productId, (current) => current + 1, ifAbsent: () => 1);
  }

  @override
  Future<void> removeFromCart({required String productId}) async {
    _quantities.remove(productId);
  }

  @override
  Future<void> decreaseQuantity({required String productId}) async {
    if (!_quantities.containsKey(productId)) {
      return;
    }

    final current = _quantities[productId]!;
    if (current <= 1) {
      _quantities.remove(productId);
      return;
    }

    _quantities[productId] = current - 1;
  }

  @override
  Future<void> clearProduct(String productId) async {
    _quantities.remove(productId);
  }
}

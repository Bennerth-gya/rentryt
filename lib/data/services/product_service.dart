import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';

abstract class ProductService {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);
}

class InMemoryProductService implements ProductService {
  InMemoryProductService() : _products = InMemorySeedData.buildProducts();

  final List<ProductModel> _products;

  @override
  Future<List<ProductModel>> getProducts() async {
    return List<ProductModel>.from(_products);
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      return _products.firstWhere((product) => product.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    _products.add(product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final index = _products.indexWhere((entry) => entry.id == product.id);
    if (index == -1) {
      _products.add(product);
      return product;
    }

    _products[index] = product;
    return product;
  }

  @override
  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((product) => product.id == productId);
  }
}

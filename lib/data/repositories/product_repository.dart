import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/services/product_service.dart';

class ProductRepository {
  ProductRepository(this._service);

  final ProductService _service;

  Future<List<ProductModel>> getProducts() => _service.getProducts();

  Future<ProductModel?> getProductById(String id) => _service.getProductById(id);

  Future<ProductModel> addProduct(ProductModel product) => _service.addProduct(product);

  Future<ProductModel> updateProduct(ProductModel product) => _service.updateProduct(product);

  Future<void> deleteProduct(String productId) => _service.deleteProduct(productId);
}

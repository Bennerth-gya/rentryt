import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/services/order_service.dart';

class OrderRepository {
  OrderRepository(this._service);

  final OrderService _service;

  Future<List<OrderModel>> getSellerOrders() => _service.getSellerOrders();
}

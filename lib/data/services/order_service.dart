import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';

abstract class OrderService {
  Future<List<OrderModel>> getSellerOrders();
}

class InMemoryOrderService implements OrderService {
  final List<OrderModel> _orders = InMemorySeedData.buildSellerOrders();

  @override
  Future<List<OrderModel>> getSellerOrders() async {
    return List<OrderModel>.from(_orders);
  }
}

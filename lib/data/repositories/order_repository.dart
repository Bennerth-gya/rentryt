import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/services/order_service.dart';

class OrderRepository {
  OrderRepository(this._service);

  final OrderService _service;

  Future<List<OrderModel>> getSellerOrders() => _service.getSellerOrders();

  Future<OrderModel> createNegotiatedOrder({
    required String chatId,
    required String offerId,
    required String productId,
    required String productName,
    required String buyerId,
    required String sellerId,
    required String customerName,
    required double amount,
    required String currency,
  }) {
    return _service.createNegotiatedOrder(
      chatId: chatId,
      offerId: offerId,
      productId: productId,
      productName: productName,
      buyerId: buyerId,
      sellerId: sellerId,
      customerName: customerName,
      amount: amount,
      currency: currency,
    );
  }

  Future<OrderModel?> getOrderById(String orderId) =>
      _service.getOrderById(orderId);
}

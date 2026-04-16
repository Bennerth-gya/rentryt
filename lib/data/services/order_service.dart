import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';
import 'package:intl/intl.dart';

abstract class OrderService {
  Future<List<OrderModel>> getSellerOrders();

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
  });

  Future<OrderModel?> getOrderById(String orderId);
}

class InMemoryOrderService implements OrderService {
  final List<OrderModel> _orders = InMemorySeedData.buildSellerOrders();

  @override
  Future<List<OrderModel>> getSellerOrders() async {
    return List<OrderModel>.from(_orders);
  }

  @override
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
  }) async {
    final order = OrderModel(
      id: 'NG-${100000 + _orders.length + 1}',
      dateLabel: DateFormat('dd MMM, yyyy').format(DateTime.now()),
      amount: amount,
      status: 'Awaiting Payment',
      paymentMethod: 'Mobile Money',
      customerName: customerName,
      itemCount: 1,
      currency: currency,
      productId: productId,
      productName: productName,
      buyerId: buyerId,
      sellerId: sellerId,
      chatId: chatId,
      offerId: offerId,
      lockedUnitPrice: amount,
      isNegotiated: true,
    );

    _orders.insert(0, order);
    return order;
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } on StateError {
      return null;
    }
  }
}

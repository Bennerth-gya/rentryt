import 'package:comfi/data/repositories/cart_repository.dart';
import 'package:comfi/data/repositories/order_repository.dart';
import 'package:comfi/data/repositories/product_repository.dart';
import 'package:comfi/presentation/state/store_controller.dart';

class Cart extends StoreController {
  Cart({
    required ProductRepository productRepository,
    required CartRepository cartRepository,
    OrderRepository? orderRepository,
  }) : super(
          productRepository: productRepository,
          cartRepository: cartRepository,
          orderRepository: orderRepository,
        );
}

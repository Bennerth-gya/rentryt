import 'package:comfi/components/products_details.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/models/products.dart';
import 'package:comfi/pages/become_a_seller_screen.dart';
import 'package:comfi/pages/cart_page.dart';
import 'package:comfi/pages/home_page.dart';
import 'package:comfi/pages/intro_page.dart';
import 'package:comfi/pages/login_page.dart';
import 'package:comfi/pages/real_signup_page.dart';
import 'package:comfi/pages/onboarding_screen.dart';
import 'package:comfi/pages/seller_orders_screen.dart';
import 'package:comfi/pages/seller_post_product_screen.dart';
import 'package:comfi/pages/seller_section/sellers_main_screen.dart';
import 'package:comfi/pages/seller_verification_screen.dart';
import 'package:comfi/pages/sellers_refund_screen.dart';
import 'package:comfi/payment/payment_method.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _route(const OnboardingScreen(), settings);
      case AppRoutes.intro:
        return _route(const IntroPage(), settings);
      case AppRoutes.login:
        return _route(const LoginPage(), settings);
      case AppRoutes.signUp:
        return _route(const SignUpPage(), settings);
      case AppRoutes.home:
        return _route(const HomePage(), settings);
      case AppRoutes.productDetails:
        final product = settings.arguments as Products;
        return _route(ProductDetailsPage(product: product), settings);
      case AppRoutes.cart:
        return _route(const CartPage(), settings);
      case AppRoutes.payment:
        return _route(const PaymentMethod(), settings);
      case AppRoutes.becomeSeller:
        return _route(const BecomeSellerScreen(), settings);
      case AppRoutes.sellerVerification:
        final phoneNumber = settings.arguments is String
            ? settings.arguments as String
            : '';
        return _route(
          SellerVerificationScreen(phoneNumber: phoneNumber),
          settings,
        );
      case AppRoutes.sellerMain:
        return _route(const SellerMainScreen(), settings);
      case AppRoutes.sellerOrders:
        final initialTab = settings.arguments is int
            ? settings.arguments as int
            : 0;
        return _route(SellerOrdersScreen(initialTab: initialTab), settings);
      case AppRoutes.sellerRefund:
        final order = settings.arguments is Map<String, dynamic>
            ? settings.arguments as Map<String, dynamic>
            : <String, dynamic>{};
        return _route(SellerRefundScreen(order: order), settings);
      case AppRoutes.sellerPostProduct:
        return _route(const SellerPostProductScreen(), settings);
      case AppRoutes.sellerEditProduct:
        final product = settings.arguments as Products?;
        return _route(
          SellerPostProductScreen(productToEdit: product),
          settings,
        );
      default:
        return _route(const OnboardingScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _route(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => child,
      settings: settings,
    );
  }
}

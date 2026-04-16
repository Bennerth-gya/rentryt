import 'package:comfi/consts/app_theme.dart';
import 'package:comfi/consts/theme_controller.dart';
import 'package:comfi/core/constants/api_endpoints.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/core/network/api_client.dart';
import 'package:comfi/core/utils/app_router.dart';
import 'package:comfi/data/repositories/auth_repository.dart';
import 'package:comfi/data/repositories/cart_repository.dart';
import 'package:comfi/data/repositories/negotiation_repository.dart';
import 'package:comfi/data/repositories/order_repository.dart';
import 'package:comfi/data/repositories/product_repository.dart';
import 'package:comfi/data/repositories/seller_repository.dart';
import 'package:comfi/data/services/auth_service.dart';
import 'package:comfi/data/services/cart_service.dart';
import 'package:comfi/data/services/negotiation_service.dart';
import 'package:comfi/data/services/order_service.dart';
import 'package:comfi/data/services/product_service.dart';
import 'package:comfi/data/services/seller_service.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/presentation/state/auth_controller.dart';
import 'package:comfi/presentation/state/seller_onboarding_controller.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
//import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // WebViewPlatform.instance = AndroidWebViewPlatform();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Register theme state once at the root.
  Get.put(ThemeController());

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(baseUrl: ApiEndpoints.baseUrl),
        ),
        Provider<ProductService>(create: (_) => InMemoryProductService()),
        Provider<CartService>(create: (_) => InMemoryCartService()),
        Provider<AuthService>(create: (_) => InMemoryAuthService()),
        Provider<OrderService>(create: (_) => InMemoryOrderService()),
        ProxyProvider<OrderService, NegotiationService>(
          update: (_, orderService, previous) =>
              InMemoryNegotiationService(orderService: orderService),
        ),
        Provider<SellerService>(create: (_) => InMemorySellerService()),
        ProxyProvider<ProductService, ProductRepository>(
          update: (_, productService, previous) =>
              ProductRepository(productService),
        ),
        ProxyProvider<CartService, CartRepository>(
          update: (_, cartService, previous) => CartRepository(cartService),
        ),
        ProxyProvider<AuthService, AuthRepository>(
          update: (_, authService, previous) => AuthRepository(authService),
        ),
        ProxyProvider<OrderService, OrderRepository>(
          update: (_, orderService, previous) => OrderRepository(orderService),
        ),
        ProxyProvider<NegotiationService, NegotiationRepository>(
          update: (_, negotiationService, previous) =>
              NegotiationRepository(negotiationService),
        ),
        ProxyProvider<SellerService, SellerRepository>(
          update: (_, sellerService, previous) =>
              SellerRepository(sellerService),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(
            productRepository: context.read<ProductRepository>(),
            cartRepository: context.read<CartRepository>(),
            orderRepository: context.read<OrderRepository>(),
          ),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) =>
              AuthController(authRepository: context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<SellerOnboardingController>(
          create: (context) => SellerOnboardingController(
            sellerRepository: context.read<SellerRepository>(),
          ),
        ),
      ],
      child: const ComfiApp(),
    ),
  );
}

class ComfiApp extends StatelessWidget {
  const ComfiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        showSemanticsDebugger: false,
        title: 'Comfi',
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),

        // ── Themes ──────────────────────────────────
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeCtrl.themeMode, // ✅ driven by controller
        // ── Global MediaQuery override ───────────────
        builder: (context, child) {
          final adjustedChild = MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.15),
              ),
            ),
            child: child!,
          );

          return DevicePreview.appBuilder(context, adjustedChild);
        },

        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.onboarding,
      ),
    );
  }
}

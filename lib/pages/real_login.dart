import 'package:comfi/data/repositories/cart_repository.dart';
import 'package:comfi/data/repositories/order_repository.dart';
import 'package:comfi/data/repositories/product_repository.dart';
import 'package:comfi/data/services/cart_service.dart';
import 'package:comfi/data/services/order_service.dart';
import 'package:comfi/data/services/product_service.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:comfi/pages/real_signup_page.dart';
import 'package:provider/provider.dart';

// ── Brand Palette ─────────────────────────────────────────────────────────────
const Color kAccent = Color(0xFFFFC843);
const Color kHighlight = Color(0xFFE83A8A);
const Color kViolet = Color(0xFF8B5CF6);
const Color kDarkBg = Color(0xFF080C14);
const Color kDarkSurface = Color(0xFF111827);
const Color kDarkCard = Color(0xFF1F2937);

class RealLogin extends StatefulWidget {
  const RealLogin({super.key});

  @override
  State<RealLogin> createState() => _RealLoginState();
}

class _RealLoginState extends State<RealLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Navigate to ShopPage wrapped with all required providers ──────────────
  void _navigateToShop() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider<ProductService>(
              create: (_) => InMemoryProductService(),
            ),
            Provider<CartService>(
              create: (_) => InMemoryCartService(),
            ),
            Provider<OrderService>(
              create: (_) => InMemoryOrderService(),
            ),
            ProxyProvider<ProductService, ProductRepository>(
              update: (_, productService, __) =>
                  ProductRepository(productService),
            ),
            ProxyProvider<CartService, CartRepository>(
              update: (_, cartService, __) => CartRepository(cartService),
            ),
            ProxyProvider<OrderService, OrderRepository>(
              update: (_, orderService, __) =>
                  OrderRepository(orderService),
            ),
            ChangeNotifierProxyProvider3<ProductRepository, CartRepository,
                OrderRepository, Cart>(
              create: (ctx) => Cart(
                productRepository: ctx.read<ProductRepository>(),
                cartRepository: ctx.read<CartRepository>(),
                orderRepository: ctx.read<OrderRepository>(),
              ),
              update: (_, productRepo, cartRepo, orderRepo, prev) =>
                  Cart(
                    productRepository: productRepo,
                    cartRepository: cartRepo,
                    orderRepository: orderRepo,
                  ),
            ),
          ],
          child: const ShopPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBg,
      body: Stack(
        children: [
          // ── Background glow effects ────────────────────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: _GlowCircle(color: kViolet.withOpacity(0.3), size: 300),
          ),
          Positioned(
            top: 80,
            left: -60,
            child:
                _GlowCircle(color: kHighlight.withOpacity(0.15), size: 200),
          ),
          Positioned(
            bottom: -80,
            right: 40,
            child: _GlowCircle(color: kAccent.withOpacity(0.12), size: 220),
          ),

          // ── Content ────────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // ── Logo pill ─────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: kViolet.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: kViolet.withOpacity(0.4), width: 1),
                        ),
                        child: const Text(
                          '✦  Welcome to Comfi',
                          style: TextStyle(
                            color: kViolet,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Headline ──────────────────────────────────────
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.8,
                          ),
                          children: [
                            TextSpan(
                              text: 'Hello\n',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            TextSpan(
                              text: 'Again! ',
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            TextSpan(
                              text: '👋',
                              style: TextStyle(fontSize: 34),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Welcome back — you've been missed.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Form card ─────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: kDarkSurface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _BrandInputField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'you@example.com',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            _BrandInputField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePassword,
                              onToggleObscure: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── Forgot password ───────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: kAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Sign In Button ────────────────────────────────
                      _GradientButton(
                        label: 'Sign In',
                        onTap: _navigateToShop,
                      ),

                      const SizedBox(height: 28),

                      // ── Divider ───────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'or continue with',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280)),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Social buttons ────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _SocialBtn(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              onTap: _navigateToShop,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SocialBtn(
                              icon: Icons.apple_rounded,
                              label: 'Apple',
                              onTap: _navigateToShop,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // ── Register link ─────────────────────────────────
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpPage()),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              text: "Not a member? ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF)),
                              children: [
                                TextSpan(
                                  text: 'Register now',
                                  style: TextStyle(
                                    color: kAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient Button ───────────────────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kViolet, kHighlight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kViolet.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Brand Input Field ─────────────────────────────────────────────────────────
class _BrandInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;

  const _BrandInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9CA3AF),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: Color(0xFF4B5563), fontSize: 15),
            prefixIcon:
                Icon(icon, size: 20, color: const Color(0xFF6B7280)),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xFF6B7280),
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            filled: true,
            fillColor: kDarkCard,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: kViolet, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: kDarkCard,
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Glow Circle ───────────────────────────────────────────────────────────────
class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
import 'package:comfi/consts/colors.dart';
import 'package:comfi/consts/theme_controller.dart';
import 'package:comfi/consts/theme_toggle_button.dart';
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
import 'package:get/get.dart';
import 'package:provider/provider.dart';

const Color _kInfoColor = Color(0xFFEF4444);

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
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToShop() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider<ProductService>(create: (_) => InMemoryProductService()),
            Provider<CartService>(create: (_) => InMemoryCartService()),
            Provider<OrderService>(create: (_) => InMemoryOrderService()),
            ProxyProvider<ProductService, ProductRepository>(
              update: (_, s, __) => ProductRepository(s),
            ),
            ProxyProvider<CartService, CartRepository>(
              update: (_, s, __) => CartRepository(s),
            ),
            ProxyProvider<OrderService, OrderRepository>(
              update: (_, s, __) => OrderRepository(s),
            ),
            ChangeNotifierProxyProvider3<ProductRepository, CartRepository,
                OrderRepository, Cart>(
              create: (ctx) => Cart(
                productRepository: ctx.read<ProductRepository>(),
                cartRepository: ctx.read<CartRepository>(),
                orderRepository: ctx.read<OrderRepository>(),
              ),
              update: (_, p, c, o, __) => Cart(
                productRepository: p,
                cartRepository: c,
                orderRepository: o,
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
    final ctrl = Get.find<ThemeController>();

    return Obx(() {
      final dark = ctrl.isDark;
      final bg = dark ? kDarkBg : kLightBg;
      final surface = dark ? kDarkSurface : kLightSurface;
      final card = dark ? kDarkCard : kLightCard;
      final fieldColor = dark ? kDarkChip : kLightChip;
      final textPrimary = dark ? Colors.white : const Color(0xFF0F172A);
      final textMuted = dark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);
      final linkColor = dark ? kAccent : kViolet;
      final borderColor = dark
          ? Colors.white.withOpacity(0.08)
          : Colors.black.withOpacity(0.07);

      return Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: [
            // Glow orbs
            Positioned(
              top: -100, right: -80,
              child: _GlowCircle(color: kViolet.withOpacity(dark ? 0.32 : 0.12), size: 300),
            ),
            Positioned(
              top: 80, left: -60,
              child: _GlowCircle(color: kHighlight.withOpacity(dark ? 0.18 : 0.08), size: 200),
            ),
            Positioned(
              bottom: -80, right: 40,
              child: _GlowCircle(color: kAccent.withOpacity(dark ? 0.15 : 0.10), size: 220),
            ),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: logo pill + theme toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: kViolet.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: kViolet.withOpacity(0.4), width: 1),
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
                            ThemeToggleButton(
                              surfaceColor: card,
                              borderColor: borderColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.8,
                            ),
                            children: [
                              TextSpan(text: 'Hello\n', style: TextStyle(color: textPrimary)),
                              TextSpan(text: 'Again! ', style: TextStyle(color: textPrimary)),
                              const TextSpan(text: '👋', style: TextStyle(fontSize: 34)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Welcome back — you've been missed.",
                          style: TextStyle(fontSize: 15, color: textMuted, letterSpacing: 0.1),
                        ),

                        const SizedBox(height: 40),

                        // Form card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderColor, width: 1),
                            boxShadow: dark
                                ? []
                                : [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 6))],
                          ),
                          child: Column(
                            children: [
                              _BrandInputField(
                                controller: _emailController,
                                label: 'Email Address',
                                hint: 'you@example.com',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                cardColor: fieldColor,
                                borderColor: borderColor,
                                textMuted: textMuted,
                                textPrimary: textPrimary,
                              ),
                              const SizedBox(height: 18),
                              _BrandInputField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                                cardColor: fieldColor,
                                borderColor: borderColor,
                                textMuted: textMuted,
                                textPrimary: textPrimary,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const _ForgotPasswordScreen(),
                              ),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: linkColor, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        _GradientButton(label: 'Sign In', onTap: _navigateToShop),

                        const SizedBox(height: 28),

                        Row(
                          children: [
                            Expanded(child: Divider(color: textMuted.withOpacity(0.2))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text('or continue with', style: TextStyle(fontSize: 12, color: textMuted)),
                            ),
                            Expanded(child: Divider(color: textMuted.withOpacity(0.2))),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(child: _SocialBtn(icon: Icons.g_mobiledata_rounded, label: 'Google', onTap: _navigateToShop, cardColor: fieldColor, borderColor: borderColor, textColor: textPrimary)),
                            const SizedBox(width: 14),
                            Expanded(child: _SocialBtn(icon: Icons.apple_rounded, label: 'Apple', onTap: _navigateToShop, cardColor: fieldColor, borderColor: borderColor, textColor: textPrimary)),
                          ],
                        ),

                        const SizedBox(height: 36),

                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
                            child: RichText(
                              text: TextSpan(
                                text: "Not a member? ",
                                style: TextStyle(fontSize: 14, color: textMuted),
                                children: [
                                  TextSpan(text: 'Register now', style: TextStyle(color: linkColor, fontWeight: FontWeight.w700)),
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
    });
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
            BoxShadow(color: kViolet.withOpacity(0.40), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
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
  final Color cardColor;
  final Color borderColor;
  final Color textMuted;
  final Color textPrimary;

  const _BrandInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.cardColor,
    required this.borderColor,
    required this.textMuted,
    required this.textPrimary,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: TextStyle(color: textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: textMuted.withOpacity(0.6), fontSize: 15),
            prefixIcon: Icon(icon, size: 20, color: textMuted),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20, color: textMuted),
                    onPressed: onToggleObscure,
                  )
                : null,
            filled: true,
            fillColor: cardColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: kViolet, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordScreen extends StatefulWidget {
  const _ForgotPasswordScreen();

  @override
  State<_ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<_ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    final email = _emailController.text.trim();
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    if (email.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Enter your email address to continue.'),
          backgroundColor: _kInfoColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text('A reset link has been sent to $email.'),
        backgroundColor: kHighlight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemeController>();

    return Obx(() {
      final dark = ctrl.isDark;
      final bg = dark ? kDarkBg : kLightBg;
      final surface = dark ? kDarkSurface : kLightSurface;
      final card = dark ? kDarkCard : kLightCard;
      final fieldColor = dark ? kDarkChip : kLightChip;
      final textPrimary = dark ? Colors.white : const Color(0xFF0F172A);
      final textMuted = dark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);
      final linkColor = dark ? kAccent : kViolet;
      final borderColor = dark
          ? Colors.white.withOpacity(0.08)
          : Colors.black.withOpacity(0.07);

      return Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: [
            Positioned(
              top: -90,
              right: -70,
              child: _GlowCircle(
                color: kViolet.withOpacity(dark ? 0.28 : 0.11),
                size: 280,
              ),
            ),
            Positioned(
              top: 90,
              left: -60,
              child: _GlowCircle(
                color: kHighlight.withOpacity(dark ? 0.16 : 0.08),
                size: 220,
              ),
            ),
            Positioned(
              bottom: -70,
              left: 10,
              child: _GlowCircle(
                color: kAccent.withOpacity(dark ? 0.14 : 0.09),
                size: 210,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        ThemeToggleButton(
                          surfaceColor: card,
                          borderColor: borderColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: kAccent.withOpacity(0.35),
                        ),
                      ),
                      child: const Text(
                        '✦  Reset your password',
                        style: TextStyle(
                          color: kAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -0.8,
                        ),
                        children: [
                          TextSpan(
                            text: 'Forgot\n',
                            style: TextStyle(color: textPrimary),
                          ),
                          const TextSpan(
                            text: 'Password?',
                            style: TextStyle(color: kViolet),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter the email tied to your Comfi account and we'll send a reset link.",
                      style: TextStyle(
                        fontSize: 15,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor),
                        boxShadow: dark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                      ),
                      child: _BrandInputField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'you@example.com',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        cardColor: fieldColor,
                        borderColor: borderColor,
                        textMuted: textMuted,
                        textPrimary: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _GradientButton(
                      label: 'Send Reset Link',
                      onTap: _sendResetLink,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: RichText(
                          text: TextSpan(
                            text: 'Remembered your password? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: textMuted,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                  color: linkColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;

  const _SocialBtn({
    required this.icon, required this.label, required this.onTap,
    required this.cardColor, required this.borderColor, required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
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
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

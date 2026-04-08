import 'package:comfi/consts/colors.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  static const String _appLogoAsset =
      'assets/images/dark_theme_real_app_logo.png';

  late AnimationController _logoAnim;
  late AnimationController _contentAnim;
  late AnimationController _buttonAnim;
  late AnimationController _orbAnim;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _contentFade;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonFade;
  late Animation<double> _orbRotate;

  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();

    _orbAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _orbRotate = Tween<double>(begin: 0, end: 1).animate(_orbAnim);

    _logoAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoAnim, curve: Curves.elasticOut));
    _logoFade = CurvedAnimation(parent: _logoAnim, curve: Curves.easeOut);

    _contentAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentAnim, curve: Curves.easeOut));
    _contentFade = CurvedAnimation(parent: _contentAnim, curve: Curves.easeOut);

    _buttonAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _buttonAnim, curve: Curves.easeOut));
    _buttonFade = CurvedAnimation(parent: _buttonAnim, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _logoAnim.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _contentAnim.forward();
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) _buttonAnim.forward();
    });
  }

  @override
  void dispose() {
    _logoAnim.dispose();
    _contentAnim.dispose();
    _buttonAnim.dispose();
    _orbAnim.dispose();
    super.dispose();
  }

  void _onShopNow() async {
    setState(() => _buttonPressed = true);
    await Future.delayed(const Duration(milliseconds: 160));
    if (!mounted) return;
    setState(() => _buttonPressed = false);
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // ── Theme-aware tokens ──────────────────────────────────
    final scaffoldBg = isDark ? kDarkBg : kLightBg;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);
    final pillBg = isDark ? kDarkSurface : kLightCard;
    final pillBorder = isDark
        ? Colors.white.withOpacity(0.07)
        : const Color(0xFFDDE3F0);
    final pillText = isDark
        ? Colors.white.withOpacity(0.55)
        : const Color(0xFF475569);
    final tagBg = isDark
        ? kViolet.withOpacity(0.12)
        : kViolet.withOpacity(0.08);
    final tagBorder = isDark
        ? kViolet.withOpacity(0.25)
        : kViolet.withOpacity(0.2);
    final tagText = isDark ? const Color(0xFFA78BFA) : const Color(0xFF6D28D9);
    final signInText = isDark
        ? Colors.white.withOpacity(0.35)
        : const Color(0xFF94A3B8);
    final logoBorder = isDark
        ? kViolet.withOpacity(0.2)
        : kViolet.withOpacity(0.25);
    final logoGlowColor = isDark
        ? kViolet.withOpacity(0.25)
        : kViolet.withOpacity(0.12);
    final orb1Color = isDark
        ? const Color(0xFF7C3AED).withOpacity(0.25)
        : const Color(0xFF7C3AED).withOpacity(0.08);
    final orb2Color = isDark
        ? const Color(0xFF4F46E5).withOpacity(0.2)
        : const Color(0xFF4F46E5).withOpacity(0.06);
    final orb3Color = isDark
        ? kViolet.withOpacity(0.12)
        : kViolet.withOpacity(0.05);
    final buttonShadow = isDark
        ? kViolet.withOpacity(0.45)
        : kViolet.withOpacity(0.3);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // ── AMBIENT ORBS ────────────────────────────────
          AnimatedBuilder(
            animation: _orbRotate,
            builder: (_, __) {
              return Stack(
                children: [
                  Positioned(
                    top: -80,
                    left: -60,
                    child: Transform.rotate(
                      angle: _orbRotate.value * 2 * 3.14159,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [orb1Color, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: -80,
                    child: Transform.rotate(
                      angle: -_orbRotate.value * 2 * 3.14159,
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [orb2Color, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.28,
                    left: size.width * 0.2,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [orb3Color, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── MAIN CONTENT ─────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // ── Logo ──────────────────────────────────
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow ring
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [logoGlowColor, Colors.transparent],
                              ),
                            ),
                          ),
                          // ── Logo container ──────────────────────────────
                          Container(
                            width: 148,
                            height: 148,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                0xFF12082A,
                              ), // dark violet bg matches logo card
                              border: Border.all(color: logoBorder, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: logoGlowColor,
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              // ✅ clips logo to circle
                              child: Image.asset(
                                _appLogoAsset,
                                fit: BoxFit
                                    .cover, // ✅ fills the circle perfectly
                                width: 148,
                                height: 148,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // ── Text content ──────────────────────────
                  FadeTransition(
                    opacity: _contentFade,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: Column(
                        children: [
                          // Brand tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: tagBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: tagBorder),
                            ),
                            child: Text(
                              'COMFI  ·  YOUR COMFORT',
                              style: TextStyle(
                                color: tagText,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Headline
                          Text(
                            'Welcome to\nComfi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: -1.5,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Subtitle
                          Text(
                            'Your comfort, our priority.\nExplore the best solutions for your needs.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: subtitleText,
                              fontSize: 15,
                              height: 1.65,
                              letterSpacing: 0.1,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Feature pills
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FeaturePill(
                                icon: Icons.local_shipping_outlined,
                                label: 'Fast Delivery',
                                bg: pillBg,
                                border: pillBorder,
                                textColor: pillText,
                              ),
                              _FeaturePill(
                                icon: Icons.verified_outlined,
                                label: 'Verified Sellers',
                                bg: pillBg,
                                border: pillBorder,
                                textColor: pillText,
                              ),
                              _FeaturePill(
                                icon: Icons.lock_outline_rounded,
                                label: 'Secure Pay',
                                bg: pillBg,
                                border: pillBorder,
                                textColor: pillText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── CTA Button ────────────────────────────
                  FadeTransition(
                    opacity: _buttonFade,
                    child: SlideTransition(
                      position: _buttonSlide,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _onShopNow,
                            child: AnimatedScale(
                              scale: _buttonPressed ? 0.96 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              child: Container(
                                width: double.infinity,
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6D28D9),
                                      Color(0xFF8B5CF6),
                                      Color(0xFFA78BFA),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: buttonShadow,
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Shop Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Sign in nudge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: signInText,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: _onShopNow,
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFFA78BFA),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── FEATURE PILL ──────────────────────────────────────────────────────────────
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color border;
  final Color textColor;

  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.bg,
    required this.border,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: kViolet),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

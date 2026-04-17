import 'package:comfi/consts/colors.dart';
import 'package:comfi/consts/theme_controller.dart';
import 'package:comfi/consts/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _fullNameController        = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _agreedToTerms   = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(
        parent: _animController, curve: Curves.easeOut);
    _slideUp =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemeController>();

    return Obx(() {
      final dark        = ctrl.isDark;
      final bg          = dark ? kDarkBg      : kLightBg;
      final surface     = dark ? kDarkSurface : kLightSurface;
      final card        = dark ? kDarkCard    : kLightCard;
      final fieldColor  = dark ? kDarkChip    : kLightChip;
      final textPrimCol = dark ? Colors.white : const Color(0xFF0F172A);
      final textMuted   = dark ? const Color(0xFF8D9EB8) : const Color(0xFF64748B);
      final borderColor = dark
          ? Colors.white.withOpacity(0.07)
          : Colors.black.withOpacity(0.07);
      final linkColor   = dark ? kAccent : kViolet;

      return Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: [
            // ── Glow orbs ──────────────────────────────────────────────────
            Positioned(
              top: -80, left: -60,
              child: _GlowCircle(
                  color: kHighlight.withOpacity(dark ? 0.22 : 0.10),
                  size: 260),
            ),
            Positioned(
              top: 200, right: -80,
              child: _GlowCircle(
                  color: kViolet.withOpacity(dark ? 0.26 : 0.12),
                  size: 220),
            ),
            Positioned(
              bottom: -60, left: 20,
              child: _GlowCircle(
                  color: kAccent.withOpacity(dark ? 0.12 : 0.08),
                  size: 180),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _GridPainter(
                  color: (dark ? Colors.white : Colors.black)
                      .withOpacity(0.025),
                ),
              ),
            ),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Back + theme toggle ──────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Container(
                                width: 42, height: 42,
                                decoration: BoxDecoration(
                                  color: card,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: borderColor, width: 1),
                                ),
                                child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: textPrimCol),
                              ),
                            ),
                            ThemeToggleButton(
                                surfaceColor: card,
                                borderColor: borderColor),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: kHighlight.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: kHighlight.withOpacity(0.35),
                                width: 1),
                          ),
                          child: const Text(
                            '✦  Create your account',
                            style: TextStyle(
                              color: kHighlight,
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
                                  text: 'Join\n',
                                  style: TextStyle(color: textPrimCol)),
                              const TextSpan(
                                  text: 'Comfi ',
                                  style: TextStyle(color: kAccent)),
                              TextSpan(
                                  text: 'today.',
                                  style: TextStyle(color: textPrimCol)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          'Thousands of happy users are waiting.',
                          style: TextStyle(fontSize: 15, color: textMuted),
                        ),

                        const SizedBox(height: 32),

                        // ── Form card ─────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderColor, width: 1),
                            boxShadow: dark
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                          ),
                          child: Column(
                            children: [
                              _BrandInputField(
                                controller:  _fullNameController,
                                label:       'Full Name',
                                hint:        'Jane Doe',
                                icon:        Icons.person_outline_rounded,
                                cardColor:   fieldColor,
                                borderColor: borderColor,
                                textMuted:   textMuted,
                                textPrimary: textPrimCol,
                              ),
                              const SizedBox(height: 18),
                              _BrandInputField(
                                controller:   _emailController,
                                label:        'Email Address',
                                hint:         'jane@example.com',
                                icon:         Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                cardColor:    fieldColor,
                                borderColor:  borderColor,
                                textMuted:    textMuted,
                                textPrimary:  textPrimCol,
                              ),
                              const SizedBox(height: 18),
                              _BrandInputField(
                                controller:      _passwordController,
                                label:           'Password',
                                hint:            '••••••••',
                                icon:            Icons.lock_outline_rounded,
                                obscure:         _obscurePassword,
                                onToggleObscure: () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                                cardColor:   fieldColor,
                                borderColor: borderColor,
                                textMuted:   textMuted,
                                textPrimary: textPrimCol,
                              ),
                              const SizedBox(height: 18),
                              _BrandInputField(
                                controller:      _confirmPasswordController,
                                label:           'Confirm Password',
                                hint:            '••••••••',
                                icon:            Icons.lock_outline_rounded,
                                obscure:         _obscureConfirm,
                                onToggleObscure: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                                cardColor:   fieldColor,
                                borderColor: borderColor,
                                textMuted:   textMuted,
                                textPrimary: textPrimCol,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Terms checkbox ────────────────────────────────────
                        GestureDetector(
                          onTap: () => setState(
                              () => _agreedToTerms = !_agreedToTerms),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22, height: 22,
                                decoration: BoxDecoration(
                                  gradient: _agreedToTerms
                                      ? const LinearGradient(
                                          colors: [kViolet, kHighlight],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: _agreedToTerms ? null : fieldColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _agreedToTerms
                                        ? Colors.transparent
                                        : textMuted.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: _agreedToTerms
                                    ? const Icon(Icons.check_rounded,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: TextStyle(
                                        fontSize: 13, color: textMuted),
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                            color: linkColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                            color: linkColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Create Account button ─────────────────────────────
                        GestureDetector(
                          onTap: _agreedToTerms ? () {} : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity, height: 56,
                            decoration: BoxDecoration(
                              gradient: _agreedToTerms
                                  ? const LinearGradient(
                                      colors: [kViolet, kHighlight],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : null,
                              color: _agreedToTerms
                                  ? null
                                  : textMuted.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _agreedToTerms
                                  ? [
                                      BoxShadow(
                                        color: kViolet.withOpacity(0.40),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  color: _agreedToTerms
                                      ? Colors.white
                                      : textMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: textMuted.withOpacity(0.2))),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              child: Text('or sign up with',
                                  style: TextStyle(
                                      fontSize: 12, color: textMuted)),
                            ),
                            Expanded(
                                child: Divider(
                                    color: textMuted.withOpacity(0.2))),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _SocialBtn(
                                icon:        Icons.g_mobiledata_rounded,
                                label:       'Google',
                                onTap:       () {},
                                cardColor:   fieldColor,
                                borderColor: borderColor,
                                textColor:   textPrimCol,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _SocialBtn(
                                icon:        Icons.apple_rounded,
                                label:       'Apple',
                                onTap:       () {},
                                cardColor:   fieldColor,
                                borderColor: borderColor,
                                textColor:   textPrimCol,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.maybePop(context),
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                    fontSize: 14, color: textMuted),
                                children: [
                                  TextSpan(
                                    text: 'Sign in',
                                    style: TextStyle(
                                        color: linkColor,
                                        fontWeight: FontWeight.w700),
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
    });
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
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller:   controller,
          obscureText:  obscure,
          keyboardType: keyboardType,
          style: TextStyle(color: textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText:  hint,
            hintStyle: TextStyle(
                color: textMuted.withOpacity(0.55), fontSize: 15),
            prefixIcon: Icon(icon, size: 20, color: textMuted),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: textMuted,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            filled:    true,
            fillColor: cardColor,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kViolet, width: 1.5),
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
  final Color cardColor;
  final Color borderColor;
  final Color textColor;

  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
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
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor),
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
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ── Grid Painter ──────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}

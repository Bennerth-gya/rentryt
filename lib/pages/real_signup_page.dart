import 'package:flutter/material.dart';
import 'dart:math' as math;

// ── Brand Palette ─────────────────────────────────────────────────────────────
const Color kAccent = Color(0xFFFFC843);
const Color kHighlight = Color(0xFFE83A8A);
const Color kViolet = Color(0xFF8B5CF6);
const Color kDarkBg = Color(0xFF080C14);
const Color kDarkSurface = Color(0xFF111827);
const Color kDarkCard = Color(0xFF1F2937);

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBg,
      body: Stack(
        children: [
          // ── Background glow effects ────────────────────────────────────────
          Positioned(
            top: -80,
            left: -60,
            child: _GlowCircle(color: kHighlight.withOpacity(0.2), size: 260),
          ),
          Positioned(
            top: 200,
            right: -80,
            child: _GlowCircle(color: kViolet.withOpacity(0.25), size: 220),
          ),
          Positioned(
            bottom: -60,
            left: 20,
            child: _GlowCircle(color: kAccent.withOpacity(0.1), size: 180),
          ),

          // ── Mesh grid decoration ───────────────────────────────────────────
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),

          // ── Main content ───────────────────────────────────────────────────
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
                      // ── Back button ────────────────────────────────────────
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: kDarkCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Badge ──────────────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: kHighlight.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: kHighlight.withOpacity(0.35), width: 1),
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

                      // ── Headline ───────────────────────────────────────────
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.8,
                          ),
                          children: [
                            TextSpan(
                              text: 'Join\n',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Comfi ',
                              style: TextStyle(color: kAccent),
                            ),
                            TextSpan(
                              text: 'today.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Thousands of happy users are waiting.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Form card ──────────────────────────────────────────
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
                              controller: _fullNameController,
                              label: 'Full Name',
                              hint: 'Jane Doe',
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 18),
                            _BrandInputField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'jane@example.com',
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
                            const SizedBox(height: 18),
                            _BrandInputField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscureConfirm,
                              onToggleObscure: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Terms checkbox ─────────────────────────────────────
                      GestureDetector(
                        onTap: () => setState(
                            () => _agreedToTerms = !_agreedToTerms),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                gradient: _agreedToTerms
                                    ? const LinearGradient(
                                        colors: [kViolet, kHighlight],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: _agreedToTerms ? null : kDarkCard,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _agreedToTerms
                                      ? Colors.transparent
                                      : Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: _agreedToTerms
                                  ? const Icon(Icons.check_rounded,
                                      size: 14, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF9CA3AF)),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: kAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: kAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Create Account Button ──────────────────────────────
                      GestureDetector(
                        onTap: _agreedToTerms ? () {} : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _agreedToTerms
                                ? const LinearGradient(
                                    colors: [kViolet, kHighlight],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color:
                                _agreedToTerms ? null : const Color(0xFF374151),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _agreedToTerms
                                ? [
                                    BoxShadow(
                                      color: kViolet.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: _agreedToTerms
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Divider ────────────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'or sign up with',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Social Buttons ─────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _SocialBtn(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SocialBtn(
                              icon: Icons.apple_rounded,
                              label: 'Apple',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ── Login Link ─────────────────────────────────────────
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF9CA3AF)),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
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
            hintStyle:
                const TextStyle(color: Color(0xFF4B5563), fontSize: 15),
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
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
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
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
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ── Grid Painter ──────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.025)
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
  bool shouldRepaint(_GridPainter old) => false;
}
import 'package:comfi/consts/colors.dart';
import 'package:comfi/consts/theme_toggle_button.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/presentation/state/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color _kLightText = Color(0xFF0F172A);
const Color _kLightSubtext = Color(0xFF64748B);
const Color _kErrorColor = Color(0xFFEF4444);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Toggle between login and "forgot password" mode
  bool _isForgotPassword = false;

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

  // ── Auth actions ───────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    final authController = context.read<AuthController>();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await authController.loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = false);

    if (authController.isAuthenticated) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final authController = context.read<AuthController>();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await authController.recoverPassword(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      // Show success and return to login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password reset email sent!'),
          backgroundColor: kHighlight,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      setState(() => _isForgotPassword = false);
    }
  }

  void _handleGoogleSignIn() {
    // Placeholder — wire to your OAuth flow
  }

  void _handleAppleSignIn() {
    // Placeholder — wire to your Apple sign-in flow
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final isSmallPhone = screenH < 680;
    final isTablet = screenW >= 600;
    final isDesktop = screenW >= 1000;

    final hPad = isDesktop
        ? screenW * 0.3
        : isTablet
            ? screenW * 0.18
            : isSmallPhone
                ? 16.0
                : 28.0;

    // Theme-aware colours
    final bgColor = isDark ? kDarkBg : kLightBg;
    final surfaceColor = isDark ? kDarkSurface : kLightSurface;
    final cardColor = isDark ? kDarkCard : kLightCard;
    final fieldColor = isDark ? kDarkChip : kLightChip;
    final subduedText = isDark ? const Color(0xFF9CA3AF) : _kLightSubtext;
    final cardBorder =
        isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.07);
    final toggleSize = isSmallPhone ? 36.0 : 42.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // ── Background glows ────────────────────────────────────────────
          Positioned(
            top: isSmallPhone ? -60 : -80,
            left: isSmallPhone ? -50 : -60,
            child: _GlowCircle(
              color: kHighlight
                  .withOpacity(isDark ? 0.18 : 0.08),
              size: isTablet ? 340 : 260,
            ),
          ),
          Positioned(
            top: isSmallPhone ? 160 : 220,
            right: isSmallPhone ? -60 : -80,
            child: _GlowCircle(
              color:
                  kViolet.withOpacity(isDark ? 0.32 : 0.12),
              size: isTablet ? 300 : 220,
            ),
          ),
          Positioned(
            bottom: isSmallPhone ? -40 : -60,
            left: 20,
            child: _GlowCircle(
              color:
                  kAccent.withOpacity(isDark ? 0.15 : 0.10),
              size: isTablet ? 240 : 180,
            ),
          ),

          // ── Mesh grid ───────────────────────────────────────────────────
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(opacity: isDark ? 0.025 : 0.06),
            ),
          ),

          // ── Main scrollable content ─────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: isSmallPhone ? 16 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Spacer so theme toggle doesn't overlap
                      SizedBox(height: isSmallPhone ? 36 : 48),

                      // ── Mode Badge ───────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _ModeBadge(
                          key: ValueKey(_isForgotPassword),
                          isForgotPassword: _isForgotPassword,
                        ),
                      ),

                      SizedBox(height: isSmallPhone ? 16 : 24),

                      // ── Headline ─────────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isForgotPassword
                            ? _Headline(
                                key: const ValueKey('forgot'),
                                line1: 'Reset your',
                                line2: 'password',
                                isDark: isDark,
                              )
                            : _Headline(
                                key: const ValueKey('login'),
                                line1: 'Welcome',
                                line2: 'back.',
                                isDark: isDark,
                              ),
                      ),

                      SizedBox(height: isSmallPhone ? 6 : 8),

                      Text(
                        _isForgotPassword
                            ? "We'll send a reset link to your email."
                            : 'Sign in to your Comfi account.',
                        style: TextStyle(
                          fontSize: isSmallPhone ? 13 : 15,
                          color: subduedText,
                        ),
                      ),

                      SizedBox(height: isSmallPhone ? 20 : 32),

                      // ── Form card ────────────────────────────────────
                      Container(
                        padding: EdgeInsets.all(isSmallPhone ? 18 : 24),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(
                              isSmallPhone ? 20 : 24),
                          border:
                              Border.all(color: cardBorder, width: 1),
                        ),
                        child: Column(
                          children: [
                            _BrandInputField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'jane@example.com',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              isDark: isDark,
                              cardColor: fieldColor,
                            ),
                            if (!_isForgotPassword) ...[
                              SizedBox(height: isSmallPhone ? 14 : 18),
                              _BrandInputField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                onToggleObscure: () => setState(
                                  () => _obscurePassword =
                                      !_obscurePassword,
                                ),
                                isDark: isDark,
                                cardColor: fieldColor,
                              ),
                            ],

                            // ── Error message ────────────────────────
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: _kErrorColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _kErrorColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: _kErrorColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // ── Forgot password link (login mode only) ────
                      if (!_isForgotPassword) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _isForgotPassword = true;
                              _errorMessage = null;
                            }),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? kAccent : kViolet,
                              ),
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: isSmallPhone ? 20 : 28),

                      // ── Primary action button ─────────────────────
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : _isForgotPassword
                                ? _handleForgotPassword
                                : _handleLogin,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: isSmallPhone ? 50 : 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kViolet, kHighlight],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                isSmallPhone ? 12 : 16),
                            boxShadow: [
                              BoxShadow(
                                color: kViolet.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    _isForgotPassword
                                        ? 'Send Reset Link'
                                        : 'Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallPhone ? 14 : 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      // ── Back to login (forgot password mode) ──────
                      if (_isForgotPassword) ...[
                        SizedBox(height: isSmallPhone ? 14 : 20),
                        Center(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _isForgotPassword = false;
                              _errorMessage = null;
                            }),
                            child: RichText(
                              text: TextSpan(
                                text: '← Back to ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subduedText,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      color:
                                          isDark ? kAccent : kViolet,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                      // ── Divider + social (login mode only) ────────
                      if (!_isForgotPassword) ...[
                        SizedBox(height: isSmallPhone ? 20 : 28),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withOpacity(
                                    isDark ? 0.15 : 0.3),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'or sign in with',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subduedText,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withOpacity(
                                    isDark ? 0.15 : 0.3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallPhone ? 14 : 20),
                        Row(
                          children: [
                            Expanded(
                              child: _SocialBtn(
                                icon: Icons.g_mobiledata_rounded,
                                label: 'Google',
                                onTap: _handleGoogleSignIn,
                                isDark: isDark,
                                cardColor: fieldColor,
                                cardBorder: cardBorder,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _SocialBtn(
                                icon: Icons.apple_rounded,
                                label: 'Apple',
                                onTap: _handleAppleSignIn,
                                isDark: isDark,
                                cardColor: fieldColor,
                                cardBorder: cardBorder,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallPhone ? 24 : 32),

                        // ── Sign-up link ─────────────────────────────
                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.signUp),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subduedText,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                      color: isDark ? kAccent : kViolet,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallPhone ? 12 : 24),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Footer ─────────────────────────────────────────────────────
          Positioned(
            bottom: bottomPad + (isSmallPhone ? 10 : 16),
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Text(
                '© 2025 Comfi — Shop with ease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallPhone ? 10.5 : 12.0,
                  color: isDark
                      ? textSecondary.withOpacity(0.3)
                      : _kLightSubtext.withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),

          // ── Theme toggle ────────────────────────────────────────────────
          Positioned(
            top: topPad + 12,
            right: 16,
            child: ThemeToggleButton(
              surfaceColor: cardColor.withOpacity(isDark ? 0.9 : 0.95),
              borderColor: cardBorder,
              size: toggleSize,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mode Badge ────────────────────────────────────────────────────────────────
class _ModeBadge extends StatelessWidget {
  final bool isForgotPassword;

  const _ModeBadge({super.key, required this.isForgotPassword});

  @override
  Widget build(BuildContext context) {
    final accentColor = isForgotPassword ? kAccent : kHighlight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: accentColor.withOpacity(0.35), width: 1),
      ),
      child: Text(
        isForgotPassword ? '🔑  Reset your password' : '✦  Welcome back',
        style: TextStyle(
          color: accentColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ── Headline ──────────────────────────────────────────────────────────────────
class _Headline extends StatelessWidget {
  final String line1;
  final String line2;
  final bool isDark;

  const _Headline({
    super.key,
    required this.line1,
    required this.line2,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallPhone = MediaQuery.of(context).size.height < 680;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isSmallPhone ? 28 : 36,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: -0.8,
        ),
        children: [
          TextSpan(
            text: '$line1\n',
            style: TextStyle(color: isDark ? Colors.white : _kLightText),
          ),
          TextSpan(
            text: line2,
            style: TextStyle(color: isDark ? Colors.white : _kLightText),
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
  final bool isDark;
  final Color cardColor;

  const _BrandInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    required this.cardColor,
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
            color: isDark ? textSecondary.withOpacity(0.8) : _kLightSubtext,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : _kLightText,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? textSecondary.withOpacity(0.35)
                  : _kLightSubtext.withOpacity(0.55),
              fontSize: 15,
            ),
            prefixIcon: Icon(icon,
                size: 20,
                color: isDark
                    ? textSecondary.withOpacity(0.65)
                    : kViolet),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: isDark
                          ? textSecondary.withOpacity(0.65)
                          : _kLightSubtext,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            filled: true,
            fillColor: cardColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : kViolet.withOpacity(0.12),
                width: 1,
              ),
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
  final bool isDark;
  final Color cardColor;
  final Color cardBorder;

  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.cardColor,
    required this.cardBorder,
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
          border: Border.all(color: cardBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 24,
                color: isDark ? Colors.white : _kLightText),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : _kLightText,
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
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.5,
            spreadRadius: size * 0.15,
          ),
        ],
      ),
    );
  }
}

// ── Grid Painter ──────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  final double opacity;
  const _GridPainter({this.opacity = 0.025});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(opacity)
      ..strokeWidth = 0.8;
    const spacing = 36.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.opacity != opacity;
}

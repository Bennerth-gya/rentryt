import 'package:comfi/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../consts/theme_toggle_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Duration get loadingTime => const Duration(milliseconds: 2000);

  Future<String?> _authUser(LoginData data) =>
      Future.delayed(loadingTime).then((_) => null);

  Future<String?> _recoverPassword(String name) =>
      Future.delayed(loadingTime).then((_) => null);

  Future<String?> _signupUser(SignupData data) =>
      Future.delayed(loadingTime).then((_) => null);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Screen measurements ───────────────────────────────
    final screenW      = MediaQuery.of(context).size.width;
    final screenH      = MediaQuery.of(context).size.height;
    final topPad       = MediaQuery.of(context).padding.top;
    final bottomPad    = MediaQuery.of(context).padding.bottom;
    final isSmallPhone = screenH < 680;
    final isTablet     = screenW >= 600;
    final isDesktop    = screenW >= 1000;

    // ── Responsive values ─────────────────────────────────
    final cardHPad     = isDesktop ? screenW * 0.28
                       : isTablet  ? screenW * 0.15
                       : isSmallPhone ? 12.0 : 20.0;
    final logoSize     = isDesktop ? 90.0 : isTablet ? 84.0
                       : isSmallPhone ? 60.0 : 76.0;
    final logoRadius   = isDesktop ? 26.0 : isTablet ? 24.0
                       : isSmallPhone ? 18.0 : 22.0;
    final logoIconSize = isDesktop ? 48.0 : isTablet ? 44.0
                       : isSmallPhone ? 30.0 : 40.0;
    final titleFs      = isDesktop ? 44.0 : isTablet ? 42.0
                       : isSmallPhone ? 28.0 : 38.0;
    final taglineFs    = isDesktop ? 14.0 : isTablet ? 13.5
                       : isSmallPhone ? 10.5 : 12.5;
    final headerGapTop    = isSmallPhone ? 6.0  : 16.0;
    final headerGapMiddle = isSmallPhone ? 3.0  : 5.0;
    final headerGapBottom = isSmallPhone ? 4.0  : 8.0;
    final inputVPad    = isSmallPhone ? 12.0 : 16.0;
    final inputHPad    = isSmallPhone ? 16.0 : 20.0;
    final inputFs      = isSmallPhone ? 13.0 : 15.0;
    final labelFs      = isSmallPhone ? 12.0 : 14.0;
    final buttonFs     = isSmallPhone ? 14.0 : 16.0;
    final cardRadius   = isTablet ? 32.0 : isSmallPhone ? 20.0 : 28.0;
    final toggleSize   = isSmallPhone ? 36.0 : 42.0;

    // ── Theme-aware colours ───────────────────────────────
    final bgColor = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final cardColor = isDark
        ? const Color(0xFF111827)
        : Colors.white;
    final cardBorder = isDark
        ? Colors.white.withOpacity(0.07)
        : const Color(0xFFE2E8F0);
    final inputFill = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFEEF1FB);
    final inputBorder = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFDDE3F0);
    final inputTextColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A);
    final glowTop = isDark
        ? const Color(0xFF7C3AED).withOpacity(0.45)
        : const Color(0xFF7C3AED).withOpacity(0.12);
    final glowBottom = isDark
        ? const Color(0xFF4C1D95).withOpacity(0.5)
        : const Color(0xFF8B5CF6).withOpacity(0.08);
    final glowMid = isDark
        ? const Color(0xFF8B5CF6).withOpacity(0.2)
        : const Color(0xFFA78BFA).withOpacity(0.1);
    final gridOpacity = isDark ? 0.025 : 0.06;

    // ── Footer text style ─────────────────────────────────
    final footerColor = isDark
        ? Colors.white.withOpacity(0.28)
        : const Color(0xFF9CA3AF);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [

          // ── Background ─────────────────────────────────
          Container(color: bgColor),

          // ── Glow — top right ───────────────────────────
          Positioned(
            top: isSmallPhone ? -80 : -120,
            right: isSmallPhone ? -70 : -100,
            child: _GlowCircle(
              size: isSmallPhone ? 240 : isTablet ? 400 : 340,
              color: glowTop,
            ),
          ),

          // ── Glow — bottom left ─────────────────────────
          Positioned(
            bottom: isSmallPhone ? -100 : -140,
            left: isSmallPhone ? -70 : -100,
            child: _GlowCircle(
              size: isSmallPhone ? 260 : isTablet ? 440 : 380,
              color: glowBottom,
            ),
          ),

          // ── Glow — mid right ───────────────────────────
          Positioned(
            top: isSmallPhone ? 180 : 260,
            right: isSmallPhone ? -40 : -60,
            child: _GlowCircle(
              size: isSmallPhone ? 140 : isTablet ? 240 : 200,
              color: glowMid,
            ),
          ),

          // ── Grid texture ───────────────────────────────
          Positioned.fill(
            child: CustomPaint(
                painter: _GridPainter(opacity: gridOpacity)),
          ),
          Center(
            child: FlutterLogin(
              title: 'Comfi',
              navigateBackAfterRecovery: true,
              onLogin: _authUser,
              onRecoverPassword: _recoverPassword,
              onSignup: _signupUser,
              loginAfterSignUp: true,
              headerWidget: _ComfiHeader(
                isDark: isDark,
                logoSize: logoSize,
                logoRadius: logoRadius,
                logoIconSize: logoIconSize,
                titleFs: titleFs,
                taglineFs: taglineFs,
                gapTop: headerGapTop,
                gapMiddle: headerGapMiddle,
                gapBottom: headerGapBottom,
              ),
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const HomePage()),
                );
              },
              theme: LoginTheme(
                cardTheme: CardTheme(
                  color: cardColor.withOpacity(isDark ? 0.95 : 1.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardRadius),
                    side: BorderSide(color: cardBorder, width: 1),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: cardHPad),
                ),
                titleStyle: const TextStyle(
                  fontSize: 0,
                  color: Colors.transparent,
                ),
                bodyStyle: TextStyle(
                  fontSize: isSmallPhone ? 12.0 : 14.0,
                  color: isDark
                      ? Colors.white.withOpacity(0.5)
                      : const Color(0xFF374151),
                ),
                switchAuthTextColor: isDark
                    ? Colors.white.withOpacity(0.55)
                    : const Color(0xFF4C1D95),
                textFieldStyle: TextStyle(
                    color: inputTextColor, fontSize: inputFs),
                inputTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: inputFill,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: inputHPad,
                    vertical: inputVPad,
                  ),
                  labelStyle: TextStyle(
                    color: isDark
                        ? Colors.white.withOpacity(0.4)
                        : const Color(0xFF6B7280),
                    fontSize: labelFs,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(isSmallPhone ? 10 : 14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(isSmallPhone ? 10 : 14),
                    borderSide:
                        BorderSide(color: inputBorder, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(isSmallPhone ? 10 : 14),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.8,
                    ),
                  ),
                  prefixIconColor: const Color(0xFF8B5CF6),
                ),
                buttonTheme: LoginButtonTheme(
                  backgroundColor: const Color(0xFF7C3AED),
                  splashColor: const Color(0xFF6D28D9),
                  elevation: 0,
                  highlightElevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(isSmallPhone ? 10 : 14),
                  ),
                ),
                buttonStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: buttonFs,
                  letterSpacing: 0.4,
                  color: Colors.white,
                ),
                primaryColor: bgColor,
                accentColor: const Color(0xFF8B5CF6),
                errorColor: const Color(0xFFEF4444),
                // Zero padding — footer is handled outside FlutterLogin
                footerBottomPadding: 0,
              ),
              // No footer prop — we render our own below
            ),
          ),

          // ── Footer — pinned to bottom, never moves ──────
          // Sits in the Stack above FlutterLogin so the form
          // expanding upward never affects its position.
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
                  color: footerColor,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),

          // ── Theme toggle — top right corner ────────────
          Positioned(
            top: topPad + 12,
            right: 16,
            child: ThemeToggleButton(
              surfaceColor:
                  cardColor.withOpacity(isDark ? 0.85 : 0.92),
              borderColor: cardBorder,
              size: toggleSize,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _ComfiHeader extends StatelessWidget {
  final bool isDark;
  final double logoSize;
  final double logoRadius;
  final double logoIconSize;
  final double titleFs;
  final double taglineFs;
  final double gapTop;
  final double gapMiddle;
  final double gapBottom;

  const _ComfiHeader({
    required this.isDark,
    required this.logoSize,
    required this.logoRadius,
    required this.logoIconSize,
    required this.titleFs,
    required this.taglineFs,
    required this.gapTop,
    required this.gapMiddle,
    required this.gapBottom,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor =
        isDark ? Colors.white : const Color(0xFF1E1B4B);
    final taglineColor = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF4C1D95);
    final ruleColor = isDark
        ? const Color(0xFF8B5CF6)
        : const Color(0xFF7C3AED);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(logoRadius),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6)
                    .withOpacity(isDark ? 0.55 : 0.3),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF7C3AED)
                    .withOpacity(isDark ? 0.3 : 0.15),
                blurRadius: 60,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: logoIconSize,
          ),
        ),

        const SizedBox(height: 30),

        Center(
          child: Text(
            'Comfi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFs,
              fontWeight: FontWeight.w800,
              color: titleColor,
              letterSpacing: 1.0,
            ),
          ),
        ),

        SizedBox(height: gapMiddle),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 18, height: 1.5, color: ruleColor),
            const SizedBox(width: 8),
            Text(
              'shop with ease',
              style: TextStyle(
                fontSize: taglineFs,
                fontStyle: FontStyle.italic,
                color: taglineColor,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 18, height: 1.5, color: ruleColor),
          ],
        ),

        SizedBox(height: gapBottom),
      ],
    );
  }
}

// ── Glow circle ───────────────────────────────────────────────────────────────
class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

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
            spreadRadius: size * 0.2,
          ),
        ],
      ),
    );
  }
}

// ── Grid painter ──────────────────────────────────────────────────────────────
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
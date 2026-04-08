import 'dart:math';

import 'package:comfi/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// ── Page data ─────────────────────────────────────────────────────────────────
class _PageData {
  final String asset;
  final String headline;
  final String body;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color orbColor1;
  final Color orbColor2;

  const _PageData({
    required this.asset,
    required this.headline,
    required this.body,
    required this.gradientColors,
    required this.accentColor,
    required this.orbColor1,
    required this.orbColor2,
  });
}

const List<_PageData> _pages = [
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-searching.gif',
    headline: 'Discover\nAnything',
    body: 'Welcome to Comfi! Search millions of unique products from trusted sellers around the world.',
    gradientColors: [Color(0xFF0D0B1A), Color(0xFF151228), Color(0xFF1A1635)],
    accentColor: Color(0xFF8B5CF6),
    orbColor1: Color(0x208B5CF6),
    orbColor2: Color(0x14B07AF0),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-shopping.gif',
    headline: 'Shop\nSeamlessly',
    body: 'Browse thousands of stylish products with a smooth experience and secure checkout.',
    gradientColors: [Color(0xFF0D0A1A), Color(0xFF160F2A), Color(0xFF1F1540)],
    accentColor: Color(0xFFB07AF0),
    orbColor1: Color(0x25B07AF0),
    orbColor2: Color(0x128B5CF6),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-delivery.gif',
    headline: 'Fast & Safe\nDelivery',
    body: 'Get your orders delivered quickly and securely right to your doorstep, every time.',
    gradientColors: [Color(0xFF080E18), Color(0xFF0E1A28), Color(0xFF152438)],
    accentColor: Color(0xFF38BDF8),
    orbColor1: Color(0x2038BDF8),
    orbColor2: Color(0x128B5CF6),
  ),
];

// ── Ecommerce floating item model ─────────────────────────────────────────────
enum _ItemType { productCard, priceTag, cartIcon, bagIcon, starRating, discountBadge }

class _FloatingItem {
  double x, y, vx, vy;
  double size;
  double opacity;
  double rotation;
  double rotationSpeed;
  _ItemType type;
  Color color;

  _FloatingItem(Size screenSize, Random rng, Color accent)
      : x = rng.nextDouble() * screenSize.width,
        y = rng.nextDouble() * screenSize.height,
        vx = (rng.nextDouble() - 0.5) * 0.25,
        vy = (rng.nextDouble() - 0.5) * 0.25,
        size = rng.nextDouble() * 24 + 16,
        opacity = rng.nextDouble() * 0.13 + 0.04,
        rotation = rng.nextDouble() * 2 * pi,
        rotationSpeed = (rng.nextDouble() - 1.0) * 0.04,
        type = _ItemType.values[rng.nextInt(_ItemType.values.length)],
        color = accent;

  void tick(Size size) {
    x += vx;
    y += vy;
    rotation += rotationSpeed;
    if (x < -60) x = size.width + 60;
    if (x > size.width + 60) x = -60;
    if (y < -60) y = size.height + 60;
    if (y > size.height + 60) y = -60;
  }
}

// ── Ecommerce background painter ──────────────────────────────────────────────
class _EcommerceBgPainter extends CustomPainter {
  final List<_FloatingItem> items;

  _EcommerceBgPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    for (final item in items) {
      canvas.save();
      canvas.translate(item.x, item.y);
      canvas.rotate(item.rotation);

      final paint = Paint()
        ..color = item.color.withOpacity(item.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;

      final fillPaint = Paint()
        ..color = item.color.withOpacity(item.opacity * 0.35)
        ..style = PaintingStyle.fill;

      final s = item.size;

      switch (item.type) {
        case _ItemType.productCard:
          _drawProductCard(canvas, paint, fillPaint, s);
          break;
        case _ItemType.priceTag:
          _drawPriceTag(canvas, paint, fillPaint, s);
          break;
        case _ItemType.cartIcon:
          _drawCart(canvas, paint, s);
          break;
        case _ItemType.bagIcon:
          _drawBag(canvas, paint, fillPaint, s);
          break;
        case _ItemType.starRating:
          _drawStars(canvas, paint, fillPaint, s);
          break;
        case _ItemType.discountBadge:
          _drawBadge(canvas, paint, fillPaint, s);
          break;
      }

      canvas.restore();
    }
  }

  void _drawProductCard(Canvas canvas, Paint stroke, Paint fill, double s) {
    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: s * 1.4, height: s * 1.8),
      Radius.circular(s * 0.18),
    );
    canvas.drawRRect(rRect, fill);
    canvas.drawRRect(rRect, stroke);
    // Image placeholder area
    final imgRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-s * 0.6, -s * 0.8, s * 1.2, s * 0.9),
      Radius.circular(s * 0.1),
    );
    canvas.drawRRect(imgRRect, stroke);
    // Price line
    canvas.drawLine(Offset(-s * 0.5, s * 0.25), Offset(s * 0.1, s * 0.25), stroke);
    // Title lines
    canvas.drawLine(Offset(-s * 0.5, s * 0.5), Offset(s * 0.5, s * 0.5), stroke);
    canvas.drawLine(Offset(-s * 0.5, s * 0.68), Offset(s * 0.2, s * 0.68), stroke);
  }

  void _drawPriceTag(Canvas canvas, Paint stroke, Paint fill, double s) {
    final path = Path();
    path.moveTo(-s * 0.5, -s * 0.65);
    path.lineTo(s * 0.5, -s * 0.65);
    path.lineTo(s * 0.5, s * 0.3);
    path.lineTo(0, s * 0.65);
    path.lineTo(-s * 0.5, s * 0.3);
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    // Hole
    canvas.drawCircle(Offset(0, -s * 0.3), s * 0.1, stroke);
    // Price lines
    canvas.drawLine(Offset(-s * 0.25, s * 0.05), Offset(s * 0.25, s * 0.05), stroke);
  }

  void _drawCart(Canvas canvas, Paint stroke, double s) {
    // Cart body
    final path = Path();
    path.moveTo(-s * 0.55, -s * 0.2);
    path.lineTo(-s * 0.35, s * 0.45);
    path.lineTo(s * 0.45, s * 0.45);
    path.lineTo(s * 0.6, -s * 0.2);
    path.close();
    canvas.drawPath(path, stroke);
    // Handle
    canvas.drawArc(
      Rect.fromCenter(center: Offset(0, -s * 0.3), width: s * 0.8, height: s * 0.6),
      pi, pi, false, stroke,
    );
    // Wheels
    canvas.drawCircle(Offset(-s * 0.2, s * 0.62), s * 0.1, stroke);
    canvas.drawCircle(Offset(s * 0.2, s * 0.62), s * 0.1, stroke);
  }

  void _drawBag(Canvas canvas, Paint stroke, Paint fill, double s) {
    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, s * 0.1), width: s * 1.2, height: s * 1.3),
      Radius.circular(s * 0.15),
    );
    canvas.drawRRect(rRect, fill);
    canvas.drawRRect(rRect, stroke);
    // Handle
    final handlePath = Path();
    handlePath.moveTo(-s * 0.3, -s * 0.45);
    handlePath.quadraticBezierTo(0, -s * 0.9, s * 0.3, -s * 0.45);
    canvas.drawPath(handlePath, stroke);
    // Comfi label lines
    canvas.drawLine(Offset(-s * 0.25, s * 0.15), Offset(s * 0.25, s * 0.15), stroke);
  }

  void _drawStars(Canvas canvas, Paint stroke, Paint fill, double s) {
    final starPaint = Paint()
      ..color = stroke.color
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      final cx = (i - 2) * s * 0.42;
      _drawStar(canvas, Offset(cx, 0), s * 0.18, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 4 * pi / 5) - pi / 2;
      final innerAngle = outerAngle + 2 * pi / 5;
      final op = Offset(center.dx + r * cos(outerAngle), center.dy + r * sin(outerAngle));
      final ip = Offset(center.dx + r * 0.4 * cos(innerAngle), center.dy + r * 0.4 * sin(innerAngle));
      if (i == 0) path.moveTo(op.dx, op.dy);
      else path.lineTo(op.dx, op.dy);
      path.lineTo(ip.dx, ip.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBadge(Canvas canvas, Paint stroke, Paint fill, double s) {
    canvas.drawCircle(Offset.zero, s * 0.6, fill);
    canvas.drawCircle(Offset.zero, s * 0.6, stroke);
    // % lines suggesting a discount
    canvas.drawLine(Offset(-s * 0.2, s * 0.2), Offset(s * 0.2, -s * 0.2), stroke);
    canvas.drawCircle(Offset(-s * 0.18, -s * 0.18), s * 0.1, stroke);
    canvas.drawCircle(Offset(s * 0.18, s * 0.18), s * 0.1, stroke);
  }

  @override
  bool shouldRepaint(_EcommerceBgPainter old) => true;
}

// ── Ecommerce Background widget ───────────────────────────────────────────────
class _EcommerceBackground extends StatefulWidget {
  final Color accentColor;

  const _EcommerceBackground({required this.accentColor});

  @override
  State<_EcommerceBackground> createState() => _EcommerceBackgroundState();
}

class _EcommerceBackgroundState extends State<_EcommerceBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<_FloatingItem> _items = [];
  final _rng = Random();
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (_items.isEmpty) return;
      for (final item in _items) {
        item.tick(_lastSize);
      }
      setState(() {});
    })..start();
  }

  @override
  void didUpdateWidget(_EcommerceBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accentColor != widget.accentColor) {
      // Smoothly tint items toward new accent
      for (final item in _items) {
        item.color = widget.accentColor;
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _initItems(Size size) {
    _lastSize = size;
    _items
      ..clear()
      ..addAll(List.generate(28, (_) => _FloatingItem(size, _rng, widget.accentColor)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (_items.isEmpty ||
            (size.width - _lastSize.width).abs() > 10 ||
            (size.height - _lastSize.height).abs() > 10) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _initItems(size));
          });
        }
        return CustomPaint(
          painter: _EcommerceBgPainter(List.from(_items)),
          size: size,
        );
      },
    );
  }
}

// ── Subtle grid lines background (gives a "store shelf" grid feel) ─────────────
class _GridLinePainter extends CustomPainter {
  final Color color;

  _GridLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.04)
      ..strokeWidth = 0.5;

    const spacing = 56.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridLinePainter old) => old.color != color;
}

// ── Main Screen ───────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late AnimationController _colorCtrl;
  Color _fromAccent = _pages[0].accentColor;
  Color _toAccent = _pages[0].accentColor;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _colorCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _fromAccent = _pages[_currentPage].accentColor;
      _toAccent = _pages[index].accentColor;
      _currentPage = index;
    });
    _colorCtrl.forward(from: 0);
    _entryCtrl.forward(from: 0);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacementNamed(context, AppRoutes.intro);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 680;
    final isTablet = size.width >= 600;
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: page.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // ── Static grid lines (marketplace grid feel) ─
            Positioned.fill(
              child: CustomPaint(
                painter: _GridLinePainter(page.accentColor),
              ),
            ),

            // ── Floating ecommerce items ───────────────────
            Positioned.fill(
              child: _EcommerceBackground(
                accentColor: page.accentColor,
              ),
            ),

            // ── Radial vignette to focus center content ────
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      page.gradientColors.last.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
            ),

            // ── Accent glow — bottom left ──────────────────
            Positioned(
              bottom: -size.width * 0.3,
              left: -size.width * 0.2,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      page.orbColor1,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Accent glow — top right ────────────────────
            Positioned(
              top: -size.width * 0.25,
              right: -size.width * 0.2,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      page.orbColor2,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Main content ──────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  _SkipRow(
                    visible: _currentPage < _pages.length - 1,
                    onSkip: _finish,
                  ),

                  Expanded(
                    flex: isSmall ? 4 : 5,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (_, i) => _GifSlide(
                        data: _pages[i],
                        size: size,
                        isSmall: isSmall,
                        isTablet: isTablet,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: isTablet ? 3 : isSmall ? 4 : 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 56 : isSmall ? 22 : 28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: isSmall ? 8 : 12),
                          _CounterBadge(
                            index: _currentPage,
                            total: _pages.length,
                            accentColor: page.accentColor,
                          ),
                          SizedBox(height: isSmall ? 14 : 18),
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: Text(
                                page.headline,
                                style: TextStyle(
                                  fontSize: isTablet ? 52 : isSmall ? 34 : 42,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.05,
                                  letterSpacing: -1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmall ? 10 : 14),
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: Text(
                                page.body,
                                maxLines: isSmall ? 3 : 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isTablet ? 17 : isSmall ? 13.5 : 15,
                                  color: Colors.white.withOpacity(0.58),
                                  height: 1.6,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isTablet ? 56 : isSmall ? 22 : 28,
                      0,
                      isTablet ? 56 : isSmall ? 22 : 28,
                      isSmall ? 24 : 40,
                    ),
                    child: Row(
                      children: [
                        _DotRow(
                          count: _pages.length,
                          current: _currentPage,
                          accentColor: page.accentColor,
                          onDotTap: (i) => _pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          ),
                        ),
                        const Spacer(),
                        _NextButton(
                          onTap: _next,
                          isLast: _currentPage == _pages.length - 1,
                          accentColor: page.accentColor,
                          colorController: _colorCtrl,
                          fromColor: _fromAccent,
                          toColor: _toAccent,
                          isSmall: isSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skip row ──────────────────────────────────────────────────────────────────
class _SkipRow extends StatelessWidget {
  final bool visible;
  final VoidCallback onSkip;

  const _SkipRow({required this.visible, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 10),
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !visible,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.white.withOpacity(0.18)),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── GIF Slide ─────────────────────────────────────────────────────────────────
class _GifSlide extends StatelessWidget {
  final _PageData data;
  final Size size;
  final bool isSmall;
  final bool isTablet;

  const _GifSlide({
    required this.data,
    required this.size,
    required this.isSmall,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final imgSize = isTablet
        ? size.width * 0.38
        : isSmall
            ? size.height * 0.26
            : size.height * 0.32;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft glow ring
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            width: imgSize * 1.55,
            height: imgSize * 1.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.accentColor.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Inner frosted card frame
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            width: imgSize * 1.15,
            height: imgSize * 1.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.accentColor.withOpacity(0.07),
              border: Border.all(
                color: data.accentColor.withOpacity(0.18),
                width: 1,
              ),
            ),
          ),
          Image.asset(
            data.asset,
            width: imgSize,
            height: imgSize,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => _GifFallback(
              size: imgSize,
              accentColor: data.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── GIF fallback ──────────────────────────────────────────────────────────────
class _GifFallback extends StatelessWidget {
  final double size;
  final Color accentColor;

  const _GifFallback({required this.size, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(0.2)),
        color: accentColor.withOpacity(0.06),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined,
              color: accentColor.withOpacity(0.4), size: size * 0.28),
          const SizedBox(height: 8),
          Text(
            'GIF asset',
            style: TextStyle(
              color: accentColor.withOpacity(0.35),
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Counter badge ─────────────────────────────────────────────────────────────
class _CounterBadge extends StatelessWidget {
  final int index;
  final int total;
  final Color accentColor;

  const _CounterBadge({
    required this.index,
    required this.total,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accentColor.withOpacity(0.25)),
      ),
      child: Text(
        '0${index + 1} / 0$total',
        style: TextStyle(
          color: accentColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// ── Dots row ──────────────────────────────────────────────────────────────────
class _DotRow extends StatelessWidget {
  final int count;
  final int current;
  final Color accentColor;
  final void Function(int) onDotTap;

  const _DotRow({
    required this.count,
    required this.current,
    required this.accentColor,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final isActive = i == current;
        return GestureDetector(
          onTap: () => onDotTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.only(right: 8),
            width: isActive ? 28 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: isActive ? accentColor : Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(4),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: accentColor.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
          ),
        );
      }),
    );
  }
}

// ── Next / Get Started button ─────────────────────────────────────────────────
class _NextButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLast;
  final Color accentColor;
  final AnimationController colorController;
  final Color fromColor;
  final Color toColor;
  final bool isSmall;

  const _NextButton({
    required this.onTap,
    required this.isLast,
    required this.accentColor,
    required this.colorController,
    required this.fromColor,
    required this.toColor,
    required this.isSmall,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.colorController,
      builder: (context, _) {
        final color = Color.lerp(
              widget.fromColor,
              widget.toColor,
              widget.colorController.value,
            ) ??
            widget.accentColor;

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: widget.isSmall ? 50 : 56,
              width: widget.isLast ? 168 : (widget.isSmall ? 50 : 56),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.55),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 40,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: widget.isLast
                      ? const Text(
                          'Get Started',
                          key: ValueKey('label'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_forward_rounded,
                          key: ValueKey('icon'),
                          color: Colors.white,
                          size: 22,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

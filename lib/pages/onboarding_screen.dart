import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:comfi/pages/intro_page.dart';

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
    gradientColors: [Color(0xFF0A0714), Color(0xFF1C1433), Color(0xFF2A1F4D)],
    accentColor: Color(0xFF8B5CF6),
    orbColor1: Color(0x2E8B5CF6),
    orbColor2: Color(0x14B07AF0),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-shopping.gif',
    headline: 'Shop\nSeamlessly',
    body: 'Browse thousands of stylish products with a smooth experience and secure checkout.',
    gradientColors: [Color(0xFF0F0819), Color(0xFF1F1238), Color(0xFF2E1B52)],
    accentColor: Color(0xFFB07AF0),
    orbColor1: Color(0x33B07AF0),
    orbColor2: Color(0x198B5CF6),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-delivery.gif',
    headline: 'Fast & Safe\nDelivery',
    body: 'Get your orders delivered quickly and securely right to your doorstep, every time.',
    gradientColors: [Color(0xFF0A1219), Color(0xFF132A38), Color(0xFF1E4557)],
    accentColor: Color(0xFF22D3EE),
    orbColor1: Color(0x2622D3EE),
    orbColor2: Color(0x198B5CF6),
  ),
];

// ── Star model ────────────────────────────────────────────────────────────────
class _Star {
  double x, y, vx, vy, r;

  _Star(Size size, Random rng)
      : x = rng.nextDouble() * size.width,
        y = rng.nextDouble() * size.height,
        vx = (rng.nextDouble() - 0.5) * 0.18,
        vy = (rng.nextDouble() - 0.5) * 0.18,
        r = rng.nextDouble() * 1.2 + 0.3;

  void tick(Size size) {
    x += vx;
    y += vy;
    if (x < 0) x = size.width;
    if (x > size.width) x = 0;
    if (y < 0) y = size.height;
    if (y > size.height) y = 0;
  }
}

// ── Constellation CustomPainter ───────────────────────────────────────────────
class _ConstellationPainter extends CustomPainter {
  final List<_Star> stars;

  _ConstellationPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFFB49FFF).withOpacity(0.7)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    final maxDist = size.width * 0.22;

    for (final s in stars) {
      canvas.drawCircle(Offset(s.x, s.y), s.r, dotPaint);
    }

    for (int i = 0; i < stars.length; i++) {
      for (int j = i + 1; j < stars.length; j++) {
        final dx = stars[i].x - stars[j].x;
        final dy = stars[i].y - stars[j].y;
        final d = sqrt(dx * dx + dy * dy);
        if (d < maxDist) {
          linePaint.color = const Color(0xFF8B5CF6)
              .withOpacity((1 - d / maxDist) * 0.25);
          canvas.drawLine(
            Offset(stars[i].x, stars[i].y),
            Offset(stars[j].x, stars[j].y),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter old) => true;
}

// ── Constellation widget — owns its Ticker and star list ──────────────────────
class _ConstellationBackground extends StatefulWidget {
  const _ConstellationBackground();

  @override
  State<_ConstellationBackground> createState() =>
      _ConstellationBackgroundState();
}

class _ConstellationBackgroundState extends State<_ConstellationBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<_Star> _stars = [];
  final _rng = Random();
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    // Ticker fires every frame → ticks stars → setState → repaint
    _ticker = createTicker((_) {
      if (_stars.isEmpty) return;
      for (final s in _stars) {
        s.tick(_lastSize);
      }
      setState(() {});
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _initStars(Size size) {
    _lastSize = size;
    _stars
      ..clear()
      ..addAll(List.generate(120, (_) => _Star(size, _rng)));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Re-seed stars only when size changes meaningfully (first build or
        // rotation). Scheduled post-frame to avoid setState-during-build.
        if (_stars.isEmpty ||
            (size.width - _lastSize.width).abs() > 10 ||
            (size.height - _lastSize.height).abs() > 10) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _initStars(size));
          });
        }

        return CustomPaint(
          painter: _ConstellationPainter(List.from(_stars)),
          size: size,
        );
      },
    );
  }
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
    _fadeAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

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
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const IntroPage(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: page.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // ── Animated constellation background ─────
            const Positioned.fill(
              child: _ConstellationBackground(),
            ),

            // ── Ambient orbs ──────────────────────────
            _AnimatedOrb(
              key: ValueKey('orb1_$_currentPage'),
              color: page.orbColor1,
              width: size.width * 0.75,
              height: size.width * 0.75,
              top: -size.width * 0.15,
              left: -size.width * 0.15,
            ),
            _AnimatedOrb(
              key: ValueKey('orb2_$_currentPage'),
              color: page.orbColor2,
              width: size.width * 0.55,
              height: size.width * 0.55,
              bottom: size.height * 0.12,
              right: -size.width * 0.12,
            ),

            // ── Main content ──────────────────────────
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
                                  fontSize: isTablet
                                      ? 52
                                      : isSmall
                                          ? 34
                                          : 42,
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
                                  fontSize: isTablet
                                      ? 17
                                      : isSmall
                                          ? 13.5
                                          : 15,
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

// ── Animated ambient orb ──────────────────────────────────────────────────────
class _AnimatedOrb extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _AnimatedOrb({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: Colors.white.withOpacity(0.18)),
                ),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            width: imgSize * 1.3,
            height: imgSize * 1.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.accentColor.withOpacity(0.22),
                  Colors.transparent,
                ],
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
              color: isActive
                  ? accentColor
                  : Colors.white.withOpacity(0.25),
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
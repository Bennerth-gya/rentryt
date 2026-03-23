import 'package:comfi/pages/intro_page.dart';
import 'package:flutter/material.dart';

// ── Page data ─────────────────────────────────────────────────────────────────
class _PageData {
  final String asset;
  final String headline;
  final String body;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color orbColor;

  const _PageData({
    required this.asset,
    required this.headline,
    required this.body,
    required this.gradientColors,
    required this.accentColor,
    required this.orbColor,
  });
}

const List<_PageData> _pages = [
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-searching.gif',
    headline: 'Discover\nAnything',
    body:
        'Welcome to Comfi! Search millions of items and find exactly what you\'re looking for in seconds.',
    gradientColors: [
      Color(0xFF0E0620),
      Color(0xFF1A0A3D),
      Color(0xFF2D1B69),
    ],
    accentColor: Color(0xFF8B5CF6),
    orbColor: Color(0xFF7C3AED),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-shopping.gif',
    headline: 'Shop\nSeamlessly',
    body:
        'Browse thousands of products and enjoy a smooth, delightful shopping experience.',
    gradientColors: [
      Color(0xFF0E0618),
      Color(0xFF1F0A3A),
      Color(0xFF3A1560),
    ],
    accentColor: Color(0xFFB07AF0),
    orbColor: Color(0xFF9333EA),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-delivery.gif',
    headline: 'Fast\nDelivery',
    body:
        'Get your orders delivered right to your door — quickly, safely, and on time.',
    gradientColors: [
      Color(0xFF020F14),
      Color(0xFF062030),
      Color(0xFF0A3D4A),
    ],
    accentColor: Color(0xFF06B6D4),
    orbColor: Color(0xFF0E7490),
  ),
];

// ── Main screen ───────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late AnimationController _colorController;
  Color _fromAccent = _pages[0].accentColor;
  Color _toAccent = _pages[0].accentColor;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _entryController.forward();
  }

  void _onPageChanged(int index) {
    _fromAccent = _pages[_currentPage].accentColor;
    _toAccent = _pages[index].accentColor;
    _colorController.forward(from: 0);
    setState(() => _currentPage = index);
    _entryController.forward(from: 0);
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
      MaterialPageRoute(builder: (_) => const IntroPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _entryController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
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

            // ── Decorative orbs ──────────────────────────
            Positioned(
              top: -100, right: -70,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      page.orbColor.withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.18, left: -90,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                width: 240, height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      page.accentColor.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60, right: -40,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      page.orbColor.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Starfield ────────────────────────────────
            Positioned.fill(
              child: CustomPaint(
                painter: _StarfieldPainter(
                    seed: _currentPage, color: page.accentColor),
              ),
            ),

            // ── Main layout ──────────────────────────────
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Skip button ───────────────────────
                  Align(
                    alignment: Alignment.topRight,
                    child: AnimatedOpacity(
                      opacity:
                          _currentPage < _pages.length - 1 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 24, top: 12),
                        child: TextButton(
                          onPressed: _finish,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.18)),
                            ),
                            backgroundColor:
                                Colors.white.withOpacity(0.06),
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── GIF PageView ──────────────────────
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) =>
                          _GifSlide(data: _pages[index]),
                    ),
                  ),

                  // ── Text + controls ───────────────────
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final availH = constraints.maxHeight;
                          final isSmall = availH < 300;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: isSmall ? 4 : 8),

                              // Page counter badge
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: page.accentColor
                                        .withOpacity(0.15),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    border: Border.all(
                                      color: page.accentColor
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '0${_currentPage + 1} / 0${_pages.length}',
                                    style: TextStyle(
                                      color: page.accentColor
                                          .withOpacity(0.9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: isSmall ? 8 : 14),

                              // Headline
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: SlideTransition(
                                  position: _slideAnim,
                                  child: Text(
                                    page.headline,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmall ? 34 : 42,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                      letterSpacing: -1.2,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: isSmall ? 8 : 14),

                              // Body text
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: SlideTransition(
                                  position: _slideAnim,
                                  child: Text(
                                    page.body,
                                    maxLines: isSmall ? 2 : 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.55),
                                      fontSize: isSmall ? 14 : 15.5,
                                      height: 1.6,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Dots + Next button
                              Row(
                                children: [
                                  _DotRow(
                                    count: _pages.length,
                                    current: _currentPage,
                                    activeColor: page.accentColor,
                                  ),
                                  const Spacer(),
                                  _NextButton(
                                    onTap: _next,
                                    isLast: _currentPage ==
                                        _pages.length - 1,
                                    accentColor: page.accentColor,
                                    colorController: _colorController,
                                    fromColor: _fromAccent,
                                    toColor: _toAccent,
                                  ),
                                ],
                              ),

                              SizedBox(height: isSmall ? 16 : 32),
                            ],
                          );
                        },
                      ),
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

// ── GIF slide ─────────────────────────────────────────────────────────────────
class _GifSlide extends StatelessWidget {
  final _PageData data;
  const _GifSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Glow halo
              Container(
                width: size.width * 0.72,
                height: size.height * 0.32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      data.accentColor.withOpacity(0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // GIF image
              Image.asset(
                data.asset,
                width: size.width * 0.75,
                height: size.height * 0.32,
                fit: BoxFit.contain,
                gaplessPlayback: true,
                errorBuilder: (context, error, _) => Container(
                  width: size.width * 0.75,
                  height: size.height * 0.32,
                  decoration: BoxDecoration(
                    color: data.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: data.accentColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported_outlined,
                          size: 56,
                          color: data.accentColor.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Text(
                          'Asset not found:\n${data.asset}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: data.accentColor.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dot row ───────────────────────────────────────────────────────────────────
class _DotRow extends StatelessWidget {
  final int count;
  final int current;
  final Color activeColor;

  const _DotRow({
    required this.count,
    required this.current,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.only(right: 6),
          width: active ? 28 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? activeColor
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
        );
      }),
    );
  }
}

// ── Next button ───────────────────────────────────────────────────────────────
class _NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLast;
  final Color accentColor;
  final AnimationController colorController;
  final Color fromColor;
  final Color toColor;

  const _NextButton({
    required this.onTap,
    required this.isLast,
    required this.accentColor,
    required this.colorController,
    required this.fromColor,
    required this.toColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorController,
      builder: (context, _) {
        final color =
            Color.lerp(fromColor, toColor, colorController.value) ??
                accentColor;
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: 56,
            width: isLast ? 168.0 : 56.0,
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
                  color: color.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLast
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
                        size: 24,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Starfield painter ─────────────────────────────────────────────────────────
class _StarfieldPainter extends CustomPainter {
  final int seed;
  final Color color;
  const _StarfieldPainter({required this.seed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.18);
    final positions = [
      Offset(size.width * 0.12, size.height * 0.08),
      Offset(size.width * 0.88, size.height * 0.15),
      Offset(size.width * 0.25, size.height * 0.22),
      Offset(size.width * 0.70, size.height * 0.32),
      Offset(size.width * 0.05, size.height * 0.45),
      Offset(size.width * 0.92, size.height * 0.52),
      Offset(size.width * 0.38, size.height * 0.68),
      Offset(size.width * 0.78, size.height * 0.72),
      Offset(size.width * 0.15, size.height * 0.82),
      Offset(size.width * 0.58, size.height * 0.88),
      Offset(size.width * 0.45, size.height * 0.12),
      Offset(size.width * 0.82, size.height * 0.40),
    ];
    final radii = [
      2.0, 1.5, 2.5, 1.5, 2.0, 1.5,
      2.0, 1.5, 2.5, 1.5, 2.0, 1.5
    ];
    for (var i = 0; i < positions.length; i++) {
      canvas.drawCircle(positions[i], radii[i % radii.length], paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.seed != seed;
}
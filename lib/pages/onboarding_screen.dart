import 'package:flutter/material.dart';
import 'package:comfi/pages/intro_page.dart';

class _PageData {
  final String asset;
  final String headline;
  final String body;
  final List<Color> gradientColors;
  final Color accentColor;

  const _PageData({
    required this.asset,
    required this.headline,
    required this.body,
    required this.gradientColors,
    required this.accentColor,
  });
}

const List<_PageData> _pages = [
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-searching.gif',
    headline: 'Discover\nAnything',
    body: 'Welcome to Comfi! Search millions of unique products from trusted sellers.',
    gradientColors: [Color(0xFF0A0714), Color(0xFF1C1433), Color(0xFF2A1F4D)],
    accentColor: Color(0xFF8B5CF6),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-shopping.gif',
    headline: 'Shop\nSeamlessly',
    body: 'Browse thousands of stylish products with smooth experience and secure checkout.',
    gradientColors: [Color(0xFF0F0819), Color(0xFF1F1238), Color(0xFF2E1B52)],
    accentColor: Color(0xFFB07AF0),
  ),
  _PageData(
    asset: 'assets/images/onboarding_animations/sammy-line-delivery.gif',
    headline: 'Fast & Safe\nDelivery',
    body: 'Get your orders delivered quickly and securely to your doorstep.',
    gradientColors: [Color(0xFF0A1219), Color(0xFF132A38), Color(0xFF1E4557)],
    accentColor: Color(0xFF22D3EE),
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
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
    _entryController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));

    _colorController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _entryController.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _fromAccent = _pages[_currentPage].accentColor;
      _toAccent = _pages[index].accentColor;
      _currentPage = index;
    });
    _colorController.forward(from: 0);
    _entryController.forward(from: 0);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IntroPage()));
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
    final isSmall = size.height < 680;

    return Scaffold(
      backgroundColor: Colors.black,
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
            // Subtle luxury grid background
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: CustomPaint(painter: _EcommerceBackgroundPainter()),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 12),
                      child: AnimatedOpacity(
                        opacity: _currentPage < _pages.length - 1 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: TextButton(
                          onPressed: _finish,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.white.withOpacity(0.15)),
                            ),
                          ),
                          child: const Text('Skip', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                  ),

                  // GIF Area
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (_, index) => _GifSlide(data: _pages[index]),
                    ),
                  ),

                  // Content + Dots + Button Area
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isSmall ? 24 : 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Page Indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: page.accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: page.accentColor.withOpacity(0.25)),
                            ),
                            child: Text(
                              '0${_currentPage + 1} / 03',
                              style: TextStyle(
                                color: page.accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Headline
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: Text(
                                page.headline,
                                style: TextStyle(
                                  fontSize: isSmall ? 36 : 44,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.05,
                                  letterSpacing: -1.4,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Body Text
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: Text(
                                page.body,
                                style: TextStyle(
                                  fontSize: isSmall ? 15 : 16.5,
                                  color: Colors.white.withOpacity(0.65),
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // ==================== DOTS + GET STARTED BUTTON ====================
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
                                isLast: _currentPage == _pages.length - 1,
                                accentColor: page.accentColor,
                                colorController: _colorController,
                                fromColor: _fromAccent,
                                toColor: _toAccent,
                              ),
                            ],
                          ),
                          SizedBox(height: isSmall ? 24 : 40),
                        ],
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

// ── Luxury Background Grid ─────────────────────────────────────
class _EcommerceBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 45) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 45) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── GIF Slide ─────────────────────────────────────────────────
class _GifSlide extends StatelessWidget {
  final _PageData data;
  const _GifSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow
          Container(
            width: size.width * 0.78,
            height: size.height * 0.34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [data.accentColor.withOpacity(0.22), Colors.transparent],
              ),
            ),
          ),
          // GIF
          Image.asset(
            data.asset,
            width: size.width * 0.78,
            height: size.height * 0.34,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
        ],
      ),
    );
  }
}

// ── Dots Indicator ─────────────────────────────────────────────
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
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.only(right: 8),
          width: isActive ? 28 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [BoxShadow(color: activeColor.withOpacity(0.6), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
        );
      }),
    );
  }
}

// ── Next / Get Started Button ───────────────────────────────────
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
        final color = Color.lerp(fromColor, toColor, colorController.value) ?? accentColor;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: 56,
            width: isLast ? 168 : 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.55), blurRadius: 22, offset: const Offset(0, 8)),
                BoxShadow(color: color.withOpacity(0.25), blurRadius: 40, offset: const Offset(0, 4)),
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
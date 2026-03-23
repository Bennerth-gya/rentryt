import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    // ── Screen measurements ─────────────────────────────
    final size        = MediaQuery.of(context).size;
    final screenW     = size.width;
    final screenH     = size.height;
    final isSmallPhone = screenH < 680;   // e.g. iPhone SE, small Tecno
    final isTablet    = screenW >= 600;
    final isDesktop   = screenW >= 1000;

    // ── Responsive sizing ───────────────────────────────
    final hPad        = isDesktop ? screenW * 0.2
                       : isTablet ? screenW * 0.12
                       : 28.0;
    final imageSize   = isDesktop ? screenW * 0.28
                       : isTablet ? screenW * 0.4
                       : isSmallPhone ? screenH * 0.28
                       : screenH * 0.35;
    final titleSize   = isDesktop ? 36.0
                       : isTablet ? 30.0
                       : isSmallPhone ? 22.0
                       : 26.0;
    final bodySize    = isDesktop ? 18.0
                       : isTablet ? 16.0
                       : isSmallPhone ? 13.0
                       : 15.0;
    final gap1        = isSmallPhone ? 20.0 : 32.0;
    final gap2        = isSmallPhone ? 10.0 : 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // ✅ Prevents overflow on very small screens or
          //    when keyboard is open
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // ── Image ─────────────────────────────
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: _buildImage(image, imageSize),
                  ),

                  SizedBox(height: gap1),

                  // ── Title ─────────────────────────────
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: gap2),

                  // ── Subtitle ──────────────────────────
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    maxLines: isSmallPhone ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: bodySize,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.55),
                      height: 1.6,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String src, double size) {
    // ── Handles both local assets and network URLs ──────
    final isNetwork = src.startsWith('http://') ||
        src.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        src,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _placeholder(size);
        },
        errorBuilder: (_, __, ___) => _errorWidget(size),
      );
    }

    return Image.asset(
      src,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _errorWidget(size),
    );
  }

  Widget _placeholder(double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8B5CF6),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _errorWidget(double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: const Color(0xFF8B5CF6).withOpacity(0.4),
            size: size * 0.25,
          ),
          SizedBox(height: size * 0.05),
          Text(
            'Image unavailable',
            style: TextStyle(
              color: const Color(0xFF8B5CF6).withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
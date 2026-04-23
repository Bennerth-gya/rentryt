import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AdaptiveScreenType { mobile, tablet, desktop }

abstract final class Responsive {
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static double mediaWidthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double widthOf(
    BuildContext context, {
    BoxConstraints? constraints,
  }) {
    final mediaWidth = mediaWidthOf(context);
    final layoutWidth = constraints?.maxWidth;
    if (layoutWidth == null || !layoutWidth.isFinite || layoutWidth <= 0) {
      return mediaWidth;
    }

    if (kIsWeb) {
      return layoutWidth;
    }

    return math.min(layoutWidth, mediaWidth);
  }

  static AdaptiveScreenType screenTypeOf(
    BuildContext context, {
    BoxConstraints? constraints,
  }) {
    final width = widthOf(context, constraints: constraints);
    if (width < mobileBreakpoint) {
      return AdaptiveScreenType.mobile;
    }
    if (width < desktopBreakpoint) {
      return AdaptiveScreenType.tablet;
    }
    return AdaptiveScreenType.desktop;
  }

  static bool isMobile(
    BuildContext context, {
    BoxConstraints? constraints,
  }) =>
      screenTypeOf(context, constraints: constraints) ==
      AdaptiveScreenType.mobile;

  static bool isTablet(
    BuildContext context, {
    BoxConstraints? constraints,
  }) =>
      screenTypeOf(context, constraints: constraints) ==
      AdaptiveScreenType.tablet;

  static bool isDesktop(
    BuildContext context, {
    BoxConstraints? constraints,
  }) =>
      screenTypeOf(context, constraints: constraints) ==
      AdaptiveScreenType.desktop;

  static bool supportsHover(
    BuildContext context, {
    BoxConstraints? constraints,
  }) =>
      kIsWeb ||
      isTablet(context, constraints: constraints) ||
      isDesktop(context, constraints: constraints);

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    BoxConstraints? constraints,
  }) {
    if (isDesktop(context, constraints: constraints)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTablet(context, constraints: constraints)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  static double horizontalPadding(
    BuildContext context, {
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
    BoxConstraints? constraints,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      constraints: constraints,
    );
  }

  static double contentMaxWidth(
    BuildContext context, {
    double mobile = double.infinity,
    double tablet = 1040,
    double desktop = 1280,
    BoxConstraints? constraints,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      constraints: constraints,
    );
  }

  static int gridCount(
    BuildContext context, {
    required int mobile,
    int? tablet,
    int? desktop,
    BoxConstraints? constraints,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? tablet ?? mobile,
      constraints: constraints,
    );
  }

  static int productGridCount(
    BuildContext context, {
    BoxConstraints? constraints,
  }) {
    final width = widthOf(context, constraints: constraints);
    if (width >= 1440) {
      return 6;
    }
    if (width >= desktopBreakpoint) {
      return 5;
    }
    if (width >= 840) {
      return 4;
    }
    if (width >= mobileBreakpoint) {
      return 3;
    }
    return 2;
  }
}

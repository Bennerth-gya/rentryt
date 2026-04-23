import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

typedef AdaptiveWidgetBuilder = Widget Function(BuildContext context);

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  final AdaptiveWidgetBuilder mobileBuilder;
  final AdaptiveWidgetBuilder? tabletBuilder;
  final AdaptiveWidgetBuilder? desktopBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = Responsive.screenTypeOf(
          context,
          constraints: constraints,
        );

        switch (screenType) {
          case AdaptiveScreenType.mobile:
            return MobileLayout(builder: mobileBuilder);
          case AdaptiveScreenType.tablet:
            return TabletLayout(builder: tabletBuilder ?? desktopBuilder ?? mobileBuilder);
          case AdaptiveScreenType.desktop:
            return DesktopLayout(
              builder: desktopBuilder ?? tabletBuilder ?? mobileBuilder,
            );
        }
      },
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key, required this.builder});

  final AdaptiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key, required this.builder});

  final AdaptiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: builder(context),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, required this.builder});

  final AdaptiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: builder(context),
    );
  }
}

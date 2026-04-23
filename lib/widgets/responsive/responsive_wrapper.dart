import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.horizontalPadding(context);
    final resolvedPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: Responsive.value(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: resolvedPadding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? Responsive.contentMaxWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

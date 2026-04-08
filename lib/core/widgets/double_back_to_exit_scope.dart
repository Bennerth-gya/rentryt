import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleBackToExitScope extends StatefulWidget {
  const DoubleBackToExitScope({
    super.key,
    required this.child,
    this.scaffoldKey,
    this.message = 'Press back again to exit',
    this.timeout = const Duration(seconds: 2),
  });

  final Widget child;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String message;
  final Duration timeout;

  @override
  State<DoubleBackToExitScope> createState() => _DoubleBackToExitScopeState();
}

class _DoubleBackToExitScopeState extends State<DoubleBackToExitScope> {
  DateTime? _lastBackPressedAt;

  bool get _shouldHandleBackPress {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android;
  }

  void _handleBackPress() {
    final isDrawerOpen =
        widget.scaffoldKey?.currentState?.isDrawerOpen ?? false;

    if (isDrawerOpen) {
      Navigator.of(context).pop();
      return;
    }

    final now = DateTime.now();
    final shouldExit =
        _lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) <= widget.timeout;

    if (shouldExit) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      SystemNavigator.pop();
      return;
    }

    _lastBackPressedAt = now;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(widget.message),
          duration: widget.timeout,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldHandleBackPress) {
      return widget.child;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _handleBackPress();
      },
      child: widget.child,
    );
  }
}

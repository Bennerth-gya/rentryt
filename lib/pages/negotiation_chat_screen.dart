import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/pages/adaptive/large_screen_negotiation_chat_screen.dart';
import 'package:comfi/pages/mobile/mobile_negotiation_chat_screen.dart';
import 'package:comfi/widgets/adaptive/adaptive_layout.dart';
import 'package:flutter/material.dart';

class NegotiationChatScreen extends StatelessWidget {
  const NegotiationChatScreen({
    super.key,
    required this.routeData,
    this.showBackButton = true,
  });

  final NegotiationChatRouteData routeData;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileBuilder: (_) => MobileNegotiationChatScreen(routeData: routeData),
      tabletBuilder: (_) => LargeScreenNegotiationChatScreen(
        routeData: routeData,
        showBackButton: showBackButton,
      ),
      desktopBuilder: (_) => LargeScreenNegotiationChatScreen(
        routeData: routeData,
        showBackButton: showBackButton,
      ),
    );
  }
}

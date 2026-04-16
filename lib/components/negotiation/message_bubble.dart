import 'dart:io';

import 'package:comfi/components/negotiation/negotiation_ui_utils.dart';
import 'package:comfi/components/negotiation/offer_card.dart';
import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/data/models/user_model.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
    required this.otherUser,
    this.currentUserAvatarPath,
    this.otherUserAvatarPath,
    this.offer,
    this.isLatestOffer = false,
    this.isBusy = false,
    this.onAcceptOffer,
    this.onRejectOffer,
    this.onCounterOffer,
  });

  final NegotiationMessageModel message;
  final UserModel currentUser;
  final UserModel otherUser;
  final String? currentUserAvatarPath;
  final String? otherUserAvatarPath;
  final NegotiationOfferModel? offer;
  final bool isLatestOffer;
  final bool isBusy;
  final VoidCallback? onAcceptOffer;
  final VoidCallback? onRejectOffer;
  final VoidCallback? onCounterOffer;

  @override
  Widget build(BuildContext context) {
    if (message.type == NegotiationMessageType.system) {
      return _SystemMessageBubble(message: message);
    }

    final isMine = message.senderId == currentUser.id;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine) ...[
            _Avatar(
              imagePath: otherUserAvatarPath,
              fallbackLabel: otherUser.name,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (message.type == NegotiationMessageType.offer &&
                    offer != null)
                  OfferCard(
                    offer: offer!,
                    isMine: isMine,
                    isLatest: isLatestOffer,
                    showActions:
                        offer!.isPending &&
                        offer!.createdById != currentUser.id,
                    showCounterAction:
                        offer!.isPending && currentUser.role == UserRole.seller,
                    isBusy: isBusy,
                    onAccept: onAcceptOffer,
                    onReject: onRejectOffer,
                    onCounter: onCounterOffer,
                  )
                else
                  Container(
                    constraints: const BoxConstraints(maxWidth: 310),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? const Color(0xFFDCF7E3)
                          : isDark
                          ? const Color(0xFF111827)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMine ? 18 : 6),
                        bottomRight: Radius.circular(isMine ? 6 : 18),
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        height: 1.42,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatMessageTime(message.timestamp),
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 6),
                      Icon(
                        deliveryStateIcon(message.deliveryState),
                        size: 13,
                        color:
                            message.deliveryState == MessageDeliveryState.seen
                            ? const Color(0xFF16A34A)
                            : secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        deliveryStateLabel(message.deliveryState),
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: 8),
            _Avatar(
              imagePath: currentUserAvatarPath,
              fallbackLabel: currentUser.name,
              backgroundColor: const Color(0xFF0F766E),
            ),
          ],
        ],
      ),
    );
  }
}

class _SystemMessageBubble extends StatelessWidget {
  const _SystemMessageBubble({required this.message});

  final NegotiationMessageModel message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillColor = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white70 : const Color(0xFF475569);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            message.content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.imagePath,
    required this.fallbackLabel,
    this.backgroundColor = const Color(0xFF1D4ED8),
  });

  final String? imagePath;
  final String fallbackLabel;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final initials = fallbackLabel.trim().isEmpty
        ? 'C'
        : fallbackLabel
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((part) => part.characters.first.toUpperCase())
              .join();

    Widget child;
    if (imagePath != null && imagePath!.startsWith('assets/')) {
      child = ClipOval(
        child: Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          width: 34,
          height: 34,
          errorBuilder: (context, error, stackTrace) => _InitialsAvatar(
            initials: initials,
            backgroundColor: backgroundColor,
          ),
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      child = ClipOval(
        child: Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          width: 34,
          height: 34,
          errorBuilder: (context, error, stackTrace) => _InitialsAvatar(
            initials: initials,
            backgroundColor: backgroundColor,
          ),
        ),
      );
    } else {
      child = _InitialsAvatar(
        initials: initials,
        backgroundColor: backgroundColor,
      );
    }

    return SizedBox(width: 34, height: 34, child: child);
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.initials,
    required this.backgroundColor,
  });

  final String initials;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

import 'package:comfi/components/negotiation/input_bar.dart';
import 'package:comfi/components/negotiation/negotiation_ui_utils.dart';
import 'package:comfi/components/negotiation/product_preview_card.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/repositories/negotiation_repository.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';
import 'package:comfi/pages/buyers_billing_details_page.dart';
import 'package:comfi/presentation/state/auth_controller.dart';
import 'package:comfi/presentation/state/negotiation_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────
const _kDarkBg       = Color(0xFF080C14);
const _kSurface      = Color(0xFF0F172A);
const _kCard         = Color(0xFF1E293B);
const _kCardDeep     = Color(0xFF111827);
const _kBorder       = Color(0x14FFFFFF); // 8% white
const _kTeal         = Color(0xFF0F766E);
const _kTealLight    = Color(0xFF0D9488);
const _kGold         = Color(0xFFFFC843);
const _kGreen        = Color(0xFF10B981);
const _kMuted        = Color(0xFF64748B);
const _kSubtle       = Color(0xFF475569);
const _kText         = Color(0xFFE2E8F0);
const _kTextSoft     = Color(0xFF94A3B8);

// ─────────────────────────────────────────────
// Route entry point (unchanged API)
// ─────────────────────────────────────────────
class MobileNegotiationChatScreen extends StatelessWidget {
  const MobileNegotiationChatScreen({super.key, required this.routeData});

  final NegotiationChatRouteData routeData;

  @override
  Widget build(BuildContext context) {
    final authController        = context.read<AuthController>();
    final negotiationRepository = context.read<NegotiationRepository>();
    final seller =
        routeData.seller ??
        InMemorySeedData.sellerForProduct(routeData.product);
    final authUser = authController.currentUser;
    final shouldUseSellerView =
        routeData.viewerRole == UserRole.seller ||
        routeData.currentUser?.id == seller.id ||
        authUser?.id == seller.id;
    final buyer = shouldUseSellerView
        ? InMemorySeedData.demoBuyer()
        : routeData.currentUser ?? authUser ?? InMemorySeedData.demoBuyer();
    final currentUser = shouldUseSellerView ? seller : buyer;

    return ChangeNotifierProvider<NegotiationChatController>(
      create: (_) => NegotiationChatController(
        negotiationRepository: negotiationRepository,
        product:     routeData.product,
        currentUser: currentUser,
        buyer:       buyer,
        seller:      seller,
      )..initialize(),
      child: const _NegotiationChatView(),
    );
  }
}

// ─────────────────────────────────────────────
// Main view
// ─────────────────────────────────────────────
class _NegotiationChatView extends StatefulWidget {
  const _NegotiationChatView();

  @override
  State<_NegotiationChatView> createState() => _NegotiationChatViewState();
}

class _NegotiationChatViewState extends State<_NegotiationChatView> {
  final ScrollController _scrollController = ScrollController();
  int  _lastMessageCount = 0;
  bool _didInitialScroll = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── build ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final controller       = context.watch<NegotiationChatController>();
    final thread           = controller.thread;
    final otherParticipant = controller.otherParticipant;

    _scheduleScrollIfNeeded(controller);

    return Scaffold(
      backgroundColor: _kDarkBg,
      // ── App bar ────────────────────────────
      appBar: AppBar(
        backgroundColor:  _kSurface,
        elevation:        0,
        surfaceTintColor: Colors.transparent,
        leading: _CircleIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: _AppBarTitle(
          controller:       controller,
          otherParticipant: otherParticipant,
          thread:           thread,
        ),
        actions: [
          _CircleIconButton(
            icon:    Icons.more_horiz_rounded,
            onTap:   () {},
            margin:  const EdgeInsets.only(right: 12),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: _kBorder,
          ),
        ),
      ),
      // ── Body ───────────────────────────────
      body: Column(
        children: [
          // Product preview
          _BeautifulProductCard(
            product:              controller.product,
            currentNegotiatedPrice:
                controller.activeOffer?.offeredPrice ?? controller.lockedPrice,
            currency: thread?.chat.currency ?? 'GHS',
          ),

          // Connection banner
          if (thread != null &&
              thread.connectionState != ChatConnectionState.connected)
            _ConnectionBanner(state: thread.connectionState),

          // Locked price banner
          if (controller.hasLockedPrice)
            _LockedPriceBanner(
              priceLabel: formatMoney(
                controller.lockedPrice ?? controller.product.price,
                currency: thread?.chat.currency ?? 'GHS',
              ),
              orderId:     controller.lockedOrderId ?? 'Pending',
              canCheckout: controller.isBuyerView,
              onCheckout:  () => _openLockedPriceCheckout(context, controller),
            ),

          // Messages
          Expanded(
            child: controller.isInitializing
                ? const Center(
                    child: CircularProgressIndicator(color: _kTealLight),
                  )
                : _MessageList(
                    controller:       controller,
                    scrollController: _scrollController,
                    onOpenOfferSheet: () =>
                        _showOfferSheet(context, controller),
                  ),
          ),

          // Input bar
          _BeautifulInputBar(
            controller:      controller.messageController,
            onChanged:       controller.onComposerChanged,
            onSend: () async {
              final error = await controller.sendTextMessage();
              if (!context.mounted || error == null) return;
              _showSnackBar(context, error, isError: true);
            },
            onOfferTap:      () => _showOfferSheet(context, controller),
            offerButtonLabel: controller.offerButtonLabel,
            isSending:       controller.isSendingMessage,
            canSend:         controller.canSendText,
            canOffer:        controller.canLaunchOfferComposer,
          ),
        ],
      ),
    );
  }

  // ── Scroll helpers ─────────────────────────
  void _scheduleScrollIfNeeded(NegotiationChatController controller) {
    final count = controller.visibleMessages.length;
    if (count == 0) return;
    if (!_didInitialScroll) {
      _didInitialScroll = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToBottom());
      _lastMessageCount = count;
      return;
    }
    if (_lastMessageCount == count) return;
    _lastMessageCount = count;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _maybeScrollToBottom());
  }

  void _jumpToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _maybeScrollToBottom() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 220) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve:    Curves.easeOut,
      );
    }
  }

  // ── Offer sheet ────────────────────────────
  Future<void> _showOfferSheet(
    BuildContext context,
    NegotiationChatController controller,
  ) async {
    if (!controller.canLaunchOfferComposer) return;

    final currency      = controller.thread?.chat.currency ?? 'GHS';
    final referencePrice =
        controller.activeOffer?.offeredPrice ?? controller.product.price;

    final suggestions = controller.isBuyerView
        ? <double>[
            referencePrice * 0.80,
            referencePrice * 0.90,
            referencePrice * 0.95,
          ]
        : <double>[
            referencePrice * 1.05,
            referencePrice * 1.10,
            controller.product.price,
          ];

    final amountController = TextEditingController(
      text: referencePrice.toStringAsFixed(2),
    );
    var isSubmitting = false;

    await showModalBottomSheet<void>(
      context:         context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (sheetCtx, setSheetState) {
              Future<void> submit() async {
                if (isSubmitting) return;
                final amount =
                    double.tryParse(amountController.text.trim());
                if (amount == null || amount <= 0) {
                  _showSnackBar(context, 'Enter a valid amount to continue.',
                      isError: true);
                  return;
                }
                setSheetState(() => isSubmitting = true);
                final error = await controller.submitOffer(amount);
                if (!sheetCtx.mounted) return;
                setSheetState(() => isSubmitting = false);
                if (error != null) {
                  _showSnackBar(context, error, isError: true);
                  return;
                }
                Navigator.of(sheetCtx).pop();
                _showSnackBar(
                  context,
                  controller.isBuyerView
                      ? 'Offer sent to the seller.'
                      : 'Counter-offer sent to the buyer.',
                );
              }

              return Container(
                decoration: const BoxDecoration(
                  color: _kSurface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _kSubtle,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title row with icon
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_kTeal, _kTealLight],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.price_change_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.offerButtonLabel,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: _kText,
                                ),
                              ),
                              Text(
                                controller.isBuyerView
                                    ? 'Send your best price'
                                    : 'Reply with a counter-offer',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _kMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Amount field
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        color: _kText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText:  'Amount ($currency)',
                        labelStyle: const TextStyle(color: _kMuted),
                        prefixText: '$currency ',
                        prefixStyle: const TextStyle(
                          color: _kGold,
                          fontWeight: FontWeight.w700,
                        ),
                        filled:      true,
                        fillColor:   _kCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:   BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: _kTealLight,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Suggestion chips
                    Wrap(
                      spacing:    8,
                      runSpacing: 8,
                      children: suggestions
                          .map((amount) => _SuggestionChip(
                                label: formatMoney(amount, currency: currency),
                                onTap: () => amountController.text =
                                    amount.toStringAsFixed(2),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 22),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isSubmitting ? null : submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: _kTeal,
                          disabledBackgroundColor: _kTeal.withValues(alpha: 0.4),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width:  18,
                                height: 18,
                                child:  CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color:       Colors.white,
                                ),
                              )
                            : Text(
                                controller.offerButtonLabel,
                                style: const TextStyle(
                                  fontSize:   15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    amountController.dispose();
  }

  // ── Locked checkout ────────────────────────
  void _openLockedPriceCheckout(
    BuildContext context,
    NegotiationChatController controller,
  ) {
    final baseData    = BillingDetailsRouteData.fromProduct(controller.product);
    final lockedPrice = controller.lockedPrice ?? controller.product.price;
    final routeData   = BillingDetailsRouteData(
      item: baseData.item.copyWith(
        negotiatedPrice: lockedPrice,
        originalPrice:   controller.product.price,
      ),
      deliveryOptions: baseData.deliveryOptions,
      savedAddress:    baseData.savedAddress,
    );
    Navigator.pushNamed(context, AppRoutes.payment, arguments: routeData);
  }

  // ── Snackbar ───────────────────────────────
  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior:        SnackBarBehavior.floating,
          backgroundColor: isError
              ? const Color(0xFF7F1D1D)
              : _kTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
  }
}

// ─────────────────────────────────────────────
// App bar title
// ─────────────────────────────────────────────
class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.controller,
    required this.otherParticipant,
    required this.thread,
  });

  final NegotiationChatController  controller;
  final dynamic                    otherParticipant;
  final NegotiationThreadSnapshot? thread;

  @override
  Widget build(BuildContext context) {
    final isOnline = thread?.isRemoteUserOnline == true;

    return Row(
      children: [
        _AvatarWithStatus(
          imagePath:     controller.product.sellerImagePath,
          fallbackLabel: otherParticipant.name,
          isOnline:      isOnline,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:       MainAxisSize.min,
            children: [
              Text(
                otherParticipant.name,
                maxLines:  1,
                overflow:  TextOverflow.ellipsis,
                style: const TextStyle(
                  color:      _kText,
                  fontSize:   16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width:  7,
                    height: 7,
                    decoration: BoxDecoration(
                      color:  isOnline ? _kGreen : _kTextSoft,
                      shape:  BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _statusText(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:      isOnline ? _kGreen : _kTextSoft,
                        fontSize:   12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _statusText() {
    if (controller.showTypingIndicator) return 'typing...';
    final state = thread?.connectionState;
    if (state == ChatConnectionState.syncing)  return 'Syncing…';
    if (state == ChatConnectionState.offline)  return 'Waiting for network';
    return thread?.isRemoteUserOnline == true ? 'Online' : 'Away';
  }
}

// ─────────────────────────────────────────────
// Beautiful product card
// ─────────────────────────────────────────────
class _BeautifulProductCard extends StatelessWidget {
  const _BeautifulProductCard({
    required this.product,
    required this.currentNegotiatedPrice,
    required this.currency,
  });

  final dynamic product;
  final double? currentNegotiatedPrice;
  final String  currency;

  @override
  Widget build(BuildContext context) {
    final original   = product.price as double;
    final negotiated = currentNegotiatedPrice;
    final hasDiscount =
        negotiated != null && negotiated < original;
    final pct = hasDiscount
        ? ((1 - negotiated! / original) * 100).round()
        : 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kCardDeep, Color(0xFF1E293B)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          // Product thumbnail
          Container(
            width:  52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kTeal, Color(0xFF1D4ED8)],
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: product.imagePath != null &&
                    (product.imagePath as String).startsWith('assets/')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      product.imagePath as String,
                      fit:          BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.shopping_bag_outlined,
                              color: Colors.white, size: 26),
                    ),
                  )
                : const Icon(Icons.shopping_bag_outlined,
                    color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color:      _kText,
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (hasDiscount) ...[
                      Text(
                        formatMoney(original, currency: currency),
                        style: const TextStyle(
                          color:     _kMuted,
                          fontSize:  11,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: _kMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      formatMoney(
                        negotiated ?? original,
                        currency: currency,
                      ),
                      style: const TextStyle(
                        color:      _kGold,
                        fontSize:   15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _kGreen.withValues(alpha: 0.12),
                          border: Border.all(
                            color: _kGreen.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '−$pct%',
                          style: const TextStyle(
                            color:      _kGreen,
                            fontSize:   9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(
            Icons.chevron_right_rounded,
            color: _kSubtle,
            size:  20,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Message list
// ─────────────────────────────────────────────
class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.controller,
    required this.scrollController,
    required this.onOpenOfferSheet,
  });

  final NegotiationChatController  controller;
  final ScrollController           scrollController;
  final Future<void> Function()    onOpenOfferSheet;

  @override
  Widget build(BuildContext context) {
    final messages = controller.visibleMessages;

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels <= 80 && controller.hasMoreMessages) {
          controller.loadOlderMessages();
        }
        if (n is ScrollEndNotification) controller.markSeen();
        return false;
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        itemCount: messages.length +
            (controller.showTypingIndicator ? 1 : 0) +
            1, // header
        itemBuilder: (context, index) {
          // ── Header row ──
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _kCard.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.hasMoreMessages
                        ? 'Scroll up to load older messages'
                        : 'Offer history is synced',
                    style: const TextStyle(
                      color:      _kMuted,
                      fontSize:   11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }

          final messageIndex = index - 1;

          // ── Typing indicator ──
          if (messageIndex >= messages.length) {
            return _TypingIndicator(
              participantName: controller.otherParticipant.name,
              avatarPath:      controller.product.sellerImagePath,
            );
          }

          final message = messages[messageIndex];
          final offer   = controller.offerForMessage(message);

          // ── System message ──
          if (message.type == NegotiationMessageType.system) {
            return _SystemMessage(content: message.content);
          }

          final isMe = message.senderId == controller.currentUser.id;

          // ── Offer bubble ──
          if (offer != null) {
            return _OfferBubbleRow(
              message:        message,
              offer:          offer,
              isMe:           isMe,
              isLatestOffer:  controller.isLatestOffer(offer.id),
              isBusy:         controller.isSendingOffer,
              currency:       controller.thread?.chat.currency ?? 'GHS',
              product:        controller.product,
              controller:     controller,
              onOpenOfferSheet: onOpenOfferSheet,
            );
          }

          // ── Text bubble ──
          return _TextBubbleRow(
            message:            message,
            isMe:               isMe,
            currentUser:        controller.currentUser,
            otherUser:          controller.otherParticipant,
            currentUserAvatar:  controller.isBuyerView
                ? null
                : controller.product.sellerImagePath,
            otherUserAvatar:    controller.isBuyerView
                ? controller.product.sellerImagePath
                : null,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// System message
// ─────────────────────────────────────────────
class _SystemMessage extends StatelessWidget {
  const _SystemMessage({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _kCard.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color:      _kMuted,
              fontSize:   11.5,
              fontWeight: FontWeight.w500,
              height:     1.4,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Text bubble row
// ─────────────────────────────────────────────
class _TextBubbleRow extends StatelessWidget {
  const _TextBubbleRow({
    required this.message,
    required this.isMe,
    required this.currentUser,
    required this.otherUser,
    required this.currentUserAvatar,
    required this.otherUserAvatar,
  });

  final NegotiationMessageModel message;
  final bool    isMe;
  final dynamic currentUser;
  final dynamic otherUser;
  final String? currentUserAvatar;
  final String? otherUserAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left:   isMe ? 64 : 12,
        right:  isMe ? 12 : 64,
        top:    2,
        bottom: 2,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _MiniAvatar(
              imagePath:     otherUserAvatar,
              fallbackLabel: otherUser.name as String,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? const LinearGradient(
                            colors: [_kTeal, _kTealLight],
                            begin:  Alignment.topLeft,
                            end:    Alignment.bottomRight,
                          )
                        : null,
                    color: isMe ? null : _kCard,
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(18),
                      topRight:    const Radius.circular(18),
                      bottomLeft:  Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color:      isMe ? Colors.white : _kText,
                      fontSize:   14,
                      height:     1.4,
                    ),
                  ),
                ),
                // Timestamp + delivery
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatMessageTime(message.timestamp),
                        style: const TextStyle(
                          color:    _kSubtle,
                          fontSize: 10,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          deliveryStateIcon(message.deliveryState),
                          size:  12,
                          color: message.deliveryState ==
                                  MessageDeliveryState.seen
                              ? const Color(0xFF60A5FA)
                              : _kSubtle,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Offer bubble row
// ─────────────────────────────────────────────
class _OfferBubbleRow extends StatelessWidget {
  const _OfferBubbleRow({
    required this.message,
    required this.offer,
    required this.isMe,
    required this.isLatestOffer,
    required this.isBusy,
    required this.currency,
    required this.product,
    required this.controller,
    required this.onOpenOfferSheet,
  });

  final NegotiationMessageModel    message;
  final NegotiationOfferModel      offer;
  final bool                        isMe;
  final bool                        isLatestOffer;
  final bool                        isBusy;
  final String                      currency;
  final dynamic                     product;
  final NegotiationChatController  controller;
  final Future<void> Function()    onOpenOfferSheet;

  @override
  Widget build(BuildContext context) {
    final originalPrice = product.price as double;
    final saving        = originalPrice - offer.offeredPrice;
    final hasSaving     = saving > 0;

    return Padding(
      padding: EdgeInsets.only(
        left:   isMe ? 48 : 12,
        right:  isMe ? 12 : 48,
        top:    6,
        bottom: 6,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _MiniAvatar(
              imagePath:     product.sellerImagePath,
              fallbackLabel: controller.otherParticipant.name as String,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: _kCardDeep,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(20),
                  topRight:    const Radius.circular(20),
                  bottomLeft:  Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                border: Border.all(color: _kBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Container(
                    width:   double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF253352)],
                        begin:  Alignment.topLeft,
                        end:    Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMe ? 'YOUR OFFER' : 'SELLER\'S OFFER',
                          style: const TextStyle(
                            color:          _kTextSoft,
                            fontSize:       9.5,
                            fontWeight:     FontWeight.w700,
                            letterSpacing:  1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$currency ',
                              style: const TextStyle(
                                color:      _kGold,
                                fontSize:   13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              offer.offeredPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                color:      _kGold,
                                fontSize:   26,
                                fontWeight: FontWeight.w800,
                                height:     1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatMoney(originalPrice, currency: currency)} original',
                          style: const TextStyle(
                            color:      _kMuted,
                            fontSize:   11,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: _kMuted,
                          ),
                        ),
                        if (hasSaving) ...[
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:  _kGreen.withValues(alpha: 0.12),
                              border: Border.all(
                                color: _kGreen.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              '↓ Save ${formatMoney(saving, currency: currency)}',
                              style: const TextStyle(
                                color:      _kGreen,
                                fontSize:   10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── Status row ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    child: Row(
                      children: [
                        _StatusPill(status: offer.status),
                        const Spacer(),
                        if (offer.status == OfferStatus.pending)
                          Text(
                            formatOfferExpiry(offer.expiresAt),
                            style: const TextStyle(
                              color:    _kSubtle,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Actions (only on latest pending, shown to non-creator) ──
                  if (isLatestOffer &&
                      offer.status == OfferStatus.pending &&
                      !isMe)
                    Column(
                      children: [
                        Divider(height: 1, color: _kBorder),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              _OfferActionButton(
                                label: 'Accept',
                                icon:  Icons.check_rounded,
                                color: _kGreen,
                                busy:  isBusy,
                                onTap: () async {
                                  final error =
                                      await controller.acceptOffer(offer);
                                  if (!context.mounted || error == null) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                },
                              ),
                              VerticalDivider(width: 1, color: _kBorder),
                              _OfferActionButton(
                                label: 'Reject',
                                icon:  Icons.close_rounded,
                                color: const Color(0xFFEF4444),
                                busy:  isBusy,
                                onTap: () async {
                                  final error =
                                      await controller.rejectOffer(offer);
                                  if (!context.mounted || error == null) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                },
                              ),
                              VerticalDivider(width: 1, color: _kBorder),
                              _OfferActionButton(
                                label: 'Counter',
                                icon:  Icons.swap_horiz_rounded,
                                color: const Color(0xFF60A5FA),
                                busy:  isBusy,
                                onTap: onOpenOfferSheet,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Status pill
// ─────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final OfferStatus status;

  @override
  Widget build(BuildContext context) {
    final color = offerStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color:  color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        offerStatusLabel(status),
        style: TextStyle(
          color:      color,
          fontSize:   10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Offer action button (Accept / Reject / Counter)
// ─────────────────────────────────────────────
class _OfferActionButton extends StatelessWidget {
  const _OfferActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.busy,
  });

  final String            label;
  final IconData          icon;
  final Color             color;
  final Future<void> Function() onTap;
  final bool              busy;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: busy ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color:      color,
                  fontSize:   12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Beautiful input bar
// ─────────────────────────────────────────────
class _BeautifulInputBar extends StatelessWidget {
  const _BeautifulInputBar({
    required this.controller,
    required this.onChanged,
    required this.onSend,
    required this.onOfferTap,
    required this.offerButtonLabel,
    required this.isSending,
    required this.canSend,
    required this.canOffer,
  });

  final TextEditingController controller;
  final ValueChanged<String>  onChanged;
  final VoidCallback          onSend;
  final VoidCallback          onOfferTap;
  final String                offerButtonLabel;
  final bool                  isSending;
  final bool                  canSend;
  final bool                  canOffer;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kSurface,
      padding: EdgeInsets.only(
        left:   12,
        right:  12,
        top:    10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          // Offer chip
          if (canOffer) ...[
            GestureDetector(
              onTap: onOfferTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 0),
                height: 44,
                decoration: BoxDecoration(
                  color:  _kGold.withValues(alpha: 0.10),
                  border: Border.all(
                    color: _kGold.withValues(alpha: 0.30),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.price_change_rounded,
                      color: _kGold,
                      size:  16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      offerButtonLabel,
                      style: const TextStyle(
                        color:      _kGold,
                        fontSize:   12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Text field
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color:  _kCard,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: _kBorder),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller,
                onChanged:  onChanged,
                style: const TextStyle(
                  color:    _kText,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText:      'Message…',
                  hintStyle:     TextStyle(color: _kSubtle, fontSize: 14),
                  border:        InputBorder.none,
                  isDense:       true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: canSend && !isSending ? onSend : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width:  44,
              height: 44,
              decoration: BoxDecoration(
                gradient: canSend
                    ? const LinearGradient(
                        colors: [_kTeal, _kTealLight],
                        begin:  Alignment.topLeft,
                        end:    Alignment.bottomRight,
                      )
                    : null,
                color: canSend ? null : _kCard,
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color:       Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: canSend ? Colors.white : _kSubtle,
                      size:  18,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Typing indicator
// ─────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({
    required this.participantName,
    this.avatarPath,
  });

  final String  participantName;
  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 64, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _MiniAvatar(
            imagePath:     avatarPath,
            fallbackLabel: participantName,
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.only(
                topLeft:     Radius.circular(18),
                topRight:    Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft:  Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _BouncingDot(delay: Duration.zero),
                SizedBox(width: 5),
                _BouncingDot(delay: Duration(milliseconds: 160)),
                SizedBox(width: 5),
                _BouncingDot(delay: Duration(milliseconds: 320)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BouncingDot extends StatefulWidget {
  const _BouncingDot({required this.delay});
  final Duration delay;

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width:  7,
          height: 7,
          decoration: BoxDecoration(
            color: Color.lerp(
              _kSubtle,
              _kTealLight,
              (_anim.value.abs() / 6).clamp(0.0, 1.0),
            )!,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Connection banner
// ─────────────────────────────────────────────
class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner({required this.state});
  final ChatConnectionState state;

  @override
  Widget build(BuildContext context) {
    final label = switch (state) {
      ChatConnectionState.connected => 'Connected',
      ChatConnectionState.syncing   => 'Syncing for low-bandwidth mode…',
      ChatConnectionState.offline   =>
          'Offline — messages will retry when connection returns.',
    };

    return Container(
      margin:  const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color:        const Color(0xFFFDE68A).withValues(alpha: 0.12),
        border:       Border.all(color: const Color(0xFFFDE68A).withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.network_check_rounded,
            size:  16,
            color: Color(0xFFFCD34D),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color:      Color(0xFFFCD34D),
                fontSize:   12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Locked price banner
// ─────────────────────────────────────────────
class _LockedPriceBanner extends StatelessWidget {
  const _LockedPriceBanner({
    required this.priceLabel,
    required this.orderId,
    required this.canCheckout,
    required this.onCheckout,
  });

  final String       priceLabel;
  final String       orderId;
  final bool         canCheckout;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), _kTeal],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              color:        Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size:  18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deal locked at $priceLabel',
                  style: const TextStyle(
                    color:      Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize:   13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Order $orderId created',
                  style: const TextStyle(
                    color:    Colors.white70,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          if (canCheckout)
            TextButton(
              onPressed: onCheckout,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                side:  const BorderSide(color: Colors.white30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize:   12.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Suggestion chip (offer sheet)
// ─────────────────────────────────────────────
class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});
  final String    label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:  _kCard,
          border: Border.all(color: _kBorder),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color:      _kText,
            fontSize:   13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mini avatar (used beside messages)
// ─────────────────────────────────────────────
class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar({
    required this.imagePath,
    required this.fallbackLabel,
    this.size = 28,
  });

  final String? imagePath;
  final String  fallbackLabel;
  final double  size;

  @override
  Widget build(BuildContext context) {
    final initials = fallbackLabel.trim().isEmpty
        ? 'C'
        : fallbackLabel
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((p) => p[0].toUpperCase())
              .join();

    final fallback = Container(
      width:  size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [_kTeal, _kTealLight]),
        shape:    BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color:      Colors.white,
          fontSize:   size * 0.32,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (imagePath == null ||
        imagePath!.isEmpty ||
        !imagePath!.startsWith('assets/')) {
      return fallback;
    }

    return ClipOval(
      child: Image.asset(
        imagePath!,
        width:  size,
        height: size,
        fit:    BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Avatar with online dot (app bar)
// ─────────────────────────────────────────────
class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({
    required this.imagePath,
    required this.fallbackLabel,
    required this.isOnline,
    this.size = 40,
  });

  final String? imagePath;
  final String  fallbackLabel;
  final bool    isOnline;
  final double  size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _MiniAvatar(
          imagePath:     imagePath,
          fallbackLabel: fallbackLabel,
          size:          size,
        ),
        Positioned(
          right:  0,
          bottom: 0,
          child: Container(
            width:  10,
            height: 10,
            decoration: BoxDecoration(
              color:  isOnline ? _kGreen : _kTextSoft,
              shape:  BoxShape.circle,
              border: Border.all(color: _kSurface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Circle icon button (app bar leading/trailing)
// ─────────────────────────────────────────────
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.margin = EdgeInsets.zero,
  });

  final IconData     icon;
  final VoidCallback onTap;
  final EdgeInsets   margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width:  36,
          height: 36,
          decoration: BoxDecoration(
            color:        Colors.white.withValues(alpha: 0.06),
            shape:        BoxShape.circle,
            border:       Border.all(color: _kBorder),
          ),
          child: Icon(icon, color: _kText, size: 18),
        ),
      ),
    );
  }
}
